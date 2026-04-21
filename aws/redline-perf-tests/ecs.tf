###
# ECS Fargate cluster — Locust redline load testing
#
# Architecture:
#   1 master task  — stays alive for ECS Exec; you launch Locust manually
#   N worker tasks — generate HTTP traffic against the target host
#
# Workers discover the master via Cloud Map DNS: master.locust.local:5557
###

locals {
  resolved_locust_image_tag = var.locust_image_tag != null && trimspace(var.locust_image_tag) != "" ? var.locust_image_tag : (var.bootstrap ? "bootstrap" : "latest")

  locust_image = var.locust_image != null && trimspace(var.locust_image) != "" ? var.locust_image : "${aws_ecr_repository.locust_redline.repository_url}:${local.resolved_locust_image_tag}"

  locust_environment = var.waf_secret != null && trimspace(var.waf_secret) != "" ? [
    {
      name  = "LOCUST_WAF_SECRET"
      value = var.waf_secret
    }
  ] : []
}

resource "aws_ecs_cluster" "locust" {
  name = "locust-redline-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  lifecycle {
    ignore_changes = [setting]
  }

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}

resource "aws_ecs_cluster_capacity_providers" "locust" {
  cluster_name       = aws_ecs_cluster.locust.name
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    base              = 1
  }
}

###
# Master task definition
###
resource "aws_ecs_task_definition" "locust_master" {
  family                   = "locust-redline-master"
  cpu                      = var.master_cpu
  memory                   = var.master_memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.locust_execution.arn
  task_role_arn            = aws_iam_role.locust_task.arn

  container_definitions = jsonencode([
    {
      name      = "locust-master"
      image     = local.locust_image
      essential = true

      environment = local.locust_environment

      entryPoint = ["/bin/sh", "-c"]
      command = [
        "trap : TERM INT; sleep infinity & wait"
      ]

      portMappings = [
        {
          containerPort = 5557
          protocol      = "tcp"
          name          = "locust-master"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.locust_master.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "locust-master"
        }
      }

      # initProcessEnabled is required for ECS Exec (`aws ecs execute-command`)
      linuxParameters = {
        initProcessEnabled = true
      }
    }
  ])

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}

###
# Worker task definition
###
resource "aws_ecs_task_definition" "locust_worker" {
  family                   = "locust-redline-worker"
  cpu                      = var.worker_cpu
  memory                   = var.worker_memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.locust_execution.arn
  task_role_arn            = aws_iam_role.locust_task.arn

  container_definitions = jsonencode([
    {
      name      = "locust-worker"
      image     = local.locust_image
      essential = true

      environment = local.locust_environment

      command = [
        "--config", var.locust_config_path,
        "-f", var.locust_file_path,
        "--host", var.locust_target_host,
        "--worker",
        "--master-host", "master.locust.local"
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.locust_worker.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "locust-worker"
        }
      }

      linuxParameters = {
        initProcessEnabled = true
      }
    }
  ])

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}

###
# Master ECS service
# The master remains in a public subnet so it has direct internet egress
# without depending on the NAT gateway, keeping the test harness cheaper.
###
resource "aws_ecs_service" "locust_master" {
  name                   = "locust-redline-master"
  cluster                = aws_ecs_cluster.locust.id
  task_definition        = aws_ecs_task_definition.locust_master.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  enable_execute_command = true

  network_configuration {
    subnets          = aws_subnet.locust_public[*].id
    security_groups  = [aws_security_group.locust_master.id]
    assign_public_ip = true
  }

  service_registries {
    registry_arn = aws_service_discovery_service.locust_master.arn
  }

  # Allow task replacement without interrupting the whole service
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  depends_on = [
    null_resource.push_locust_redline_docker_image
  ]

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}

###
# Worker ECS service
# Workers live in private subnets and use NAT GW for outbound traffic.
# Scale up/down with: aws ecs update-service --cluster locust-redline-cluster \
#   --service locust-redline-workers --desired-count N
###
resource "aws_ecs_service" "locust_workers" {
  name                   = "locust-redline-workers"
  cluster                = aws_ecs_cluster.locust.id
  task_definition        = aws_ecs_task_definition.locust_worker.arn
  desired_count          = var.locust_worker_count
  launch_type            = "FARGATE"
  enable_execute_command = true

  network_configuration {
    subnets          = aws_subnet.locust_private[*].id
    security_groups  = [aws_security_group.locust_worker.id]
    assign_public_ip = false
  }

  depends_on = [
    aws_ecs_service.locust_master,
    null_resource.push_locust_redline_docker_image
  ]

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}
