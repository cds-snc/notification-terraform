locals {
  image_tag = var.env == "production" ? var.blazer_image_tag : "latest"
}

resource "aws_ecs_cluster" "blazer" {
  name = "blazer"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "blazer" {
  name                   = "blazer"
  cluster                = aws_ecs_cluster.blazer.id
  task_definition        = aws_ecs_task_definition.blazer.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  enable_execute_command = true

  network_configuration {
    security_groups = [var.database-tools-securitygroup]
    subnets         = var.vpc_private_subnets
  }
}

resource "aws_ecs_task_definition" "blazer" {
  family                   = "blazer"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = 256
  memory = 512

  execution_role_arn = aws_iam_role.blazer_execution_role.arn
  task_role_arn      = aws_iam_role.blazer_ecs_task.arn

  container_definitions = jsonencode([
    {
      "name" : "blazer",
      "cpu" : 0,
      "essential" : true,
      "image" : "${aws_ecr_repository.blazer.repository_url}:${local.image_tag}",
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "${var.cloudwatch_enabled ? aws_cloudwatch_log_group.blazer[0].name : "none"}",
          "awslogs-region" : "${var.region}",
          "awslogs-stream-prefix" : "blazer"
        }
      },
      "portMappings" : [
        {
          "hostPort" : 8080,
          "ContainerPort" : 8080,
          "Protocol" : "tcp"
        }
      ],
      "environment" : [{
        "name" : "LOG_LEVEL",
        "value" : "info"
        }, {
        "name" : "NOTIFY_URL",
        "value" : "https://${var.domain}"
      }],
      "secrets" : [{
        "name" : "BLAZER_DATABASE_URL",
        "valueFrom" : "${aws_ssm_parameter.sqlalchemy_database_reader_uri.arn}"
        }, {
        "name" : "DATABASE_URL",
        "valueFrom" : "${aws_ssm_parameter.db_tools_environment_variables.arn}"
        }, {
        "name" : "GOOGLE_OAUTH_CLIENT_ID",
        "valueFrom" : "${aws_ssm_parameter.notify_o11y_google_oauth_client_id.arn}"
        }, {
        "name" : "GOOGLE_OAUTH_CLIENT_SECRET",
        "valueFrom" : "${aws_ssm_parameter.notify_o11y_google_oauth_client_secret.arn}"
      }]
    }
  ])
}
