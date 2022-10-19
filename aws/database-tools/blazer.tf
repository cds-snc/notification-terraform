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

resource "aws_ssm_parameter" "sqlalchemy_database_reader_uri" {
  name  = "sqlalchemy_database_reader_uri"
  type  = "SecureString"
  value = var.sqlalchemy_database_reader_uri

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
    Terraform             = true
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
      "image" : "ankane/blazer:v2.6.5",
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "${aws_cloudwatch_log_group.blazer.name}",
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
      "secrets" : [{
        "name" : "DATABASE_URL",
        "valueFrom" : "${aws_ssm_parameter.sqlalchemy_database_reader_uri.arn}"
        }, {
        "name" : "BLAZER_DATABASE_URL",
        "valueFrom" : "${aws_ssm_paramter.db_tools_environment_variables.arn}"
      }]
    }
  ])
}
