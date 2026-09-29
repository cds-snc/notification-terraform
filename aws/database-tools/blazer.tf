locals {
  use_manifest_image  = var.env != "sandbox" && !var.bootstrap
  image_tag           = local.use_manifest_image ? yamldecode(data.github_repository_file.manifests_env[0].content)["BLAZER_DOCKER_TAG"] : null
  ecr_image_available = local.use_manifest_image
  ecr_repository_name = aws_ecr_repository.blazer.name
}

data "github_repository_file" "manifests_env" {
  count      = local.use_manifest_image ? 1 : 0
  repository = "notification-manifests"
  branch     = "main"
  file       = "helmfile/overrides/${var.env}.env"
}

data "aws_ecr_image" "blazer" {
  count           = local.ecr_image_available ? 1 : 0
  repository_name = local.ecr_repository_name
  image_tag       = local.image_tag
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
      "image" : local.ecr_image_available ? data.aws_ecr_image.blazer[0].image_uri : "${aws_ecr_repository.blazer.repository_url}:${var.bootstrap ? "bootstrap" : "latest"}",
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "${var.cloudwatch_enabled ? "blazer" : "none"}",
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
        "value" : "https://${var.base_domain}"
      }],
      "secrets" : [{
        "name" : "BLAZER_DATABASE_URL",
        "valueFrom" : "${aws_ssm_parameter.sqlalchemy_database_reader_uri.arn}"
        }, {
        "name" : "BLAZER_CHECKS_DATABASE_URL",
        "valueFrom" : "${aws_ssm_parameter.blazer_checks_database_url.arn}"
        }, {
        "name" : "DATABASE_URL",
        "valueFrom" : "${aws_ssm_parameter.db_tools_environment_variables.arn}"
        }, {
        "name" : "BLAZER_SLACK_WEBHOOK_URL",
        "valueFrom" : "${aws_ssm_parameter.blazer_slack_webhook_general_topic.arn}"
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
