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
    security_groups = [aws_security_group.blazer.id]
    subnets         = var.vpc_private_subnets
  }
}

resource "aws_ecs_task_definition" "blazer" {
  family                   = "blazer"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  vars = {
    DATABASE_URL = aws_ssm_parameter.sqlalchemy_database_reader_uri.arn
  }

  cpu    = 256
  memory = 512

  execution_role_arn = aws_iam_role.blazer_execution_role.arn
  task_role_arn      = aws_iam_role.blazer_ecs_task.arn

  container_definitions = jsonencode([
    {
      "name" : "httpd",
      "cpu" : 0,
      "essential" : true,
      "image" : "ankane/blazer:latest",
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : aws_cloudwatch_log_group.blazer.name,
          "awslogs-region" : var.region,
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
        "value" : "${sqlalchemy_database_reader_uri}",
      }]
    }
  ])
}
