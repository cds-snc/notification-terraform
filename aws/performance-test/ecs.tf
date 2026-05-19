#
# ECS Fargate cluster
#

resource "aws_ecs_cluster" "perf_test" {
  name = "performance_test_cluster"

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

resource "aws_ecs_cluster_capacity_providers" "perf_test" {
  cluster_name       = aws_ecs_cluster.perf_test.name
  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    base              = 1
  }
}

#
# Task
#

resource "aws_ecs_task_definition" "perf_test_task" {
  family                   = aws_ecs_cluster.perf_test.name
  cpu                      = 2048
  memory                   = 4096
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.container_execution_role.arn
  task_role_arn            = aws_iam_role.perf_test_ecs_task.arn

  container_definitions = jsonencode([
    {
      name        = "performance-tests-container"
      image       = var.performance_test_ecr_repository_url
      essential   = true
      cpu         = 0
      volumesFrom = []

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.cloudwatch_enabled ? aws_cloudwatch_log_group.perf_test_ecs_logs[0].name : "none"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "${aws_ecs_cluster.perf_test.name}-task"
        }
      }

      ulimits = [
        { name = "nofile", softLimit = 98304, hardLimit = 98304 }
      ]

      environment = [
        { name = "PERF_TEST_AWS_S3_BUCKET", value = var.perf_test_aws_s3_bucket },
        { name = "PERF_TEST_CSV_DIRECTORY_PATH", value = var.perf_test_csv_directory_path },
        { name = "PERF_TEST_SMS_TEMPLATE_ID_ONE_VAR", value = var.perf_test_sms_template_id_one_var },
        { name = "PERF_TEST_EMAIL_TEMPLATE_ID_ONE_VAR", value = var.perf_test_email_template_id_one_var },
      ]

      secrets = var.env == "production" ? [] : [
        { name = "PERF_TEST_PHONE_NUMBER", valueFrom = aws_secretsmanager_secret_version.perf_test_phone_number[0].arn },
        { name = "PERF_TEST_EMAIL_ADDRESS", valueFrom = aws_secretsmanager_secret_version.perf_test_email[0].arn },
        { name = "PERF_TEST_DOMAIN", valueFrom = aws_secretsmanager_secret_version.perf_test_domain[0].arn },
        { name = "PERF_TEST_API_KEY", valueFrom = aws_secretsmanager_secret_version.perf_test_api_key[0].arn },
        { name = "PERF_TEST_SLACK_WEBHOOK", valueFrom = aws_secretsmanager_secret_version.perf_test_slack_webhook[0].arn },
        { name = "DATABASE_READER_URI", valueFrom = aws_secretsmanager_secret_version.perf_test_database_uri[0].arn },
      ]
    }
  ])

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}

#
# Redline Task
#

resource "aws_ecs_task_definition" "redline_perf_test_task" {
  family                   = "redline_performance_test"
  cpu                      = 2048
  memory                   = 4096
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.container_execution_role.arn
  task_role_arn            = aws_iam_role.perf_test_ecs_task.arn

  container_definitions = jsonencode([
    {
      name        = "redline-performance-tests-container"
      image       = var.performance_test_ecr_repository_url
      essential   = true
      cpu         = 0
      volumesFrom = []

      entryPoint = ["./run_failure_scenarios.sh"]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.cloudwatch_enabled ? aws_cloudwatch_log_group.perf_test_ecs_logs[0].name : "none"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "redline_performance_test-task"
        }
      }

      ulimits = [
        { name = "nofile", softLimit = 98304, hardLimit = 98304 }
      ]

      environment = [
        { name = "PERF_TEST_AWS_S3_BUCKET", value = var.perf_test_aws_s3_bucket },
        { name = "PERF_TEST_CSV_DIRECTORY_PATH", value = var.perf_test_csv_directory_path },
        { name = "PERF_TEST_SMS_TEMPLATE_ID_ONE_VAR", value = var.perf_test_sms_template_id_one_var },
        { name = "PERF_TEST_EMAIL_TEMPLATE_ID_ONE_VAR", value = var.perf_test_email_template_id_one_var },
      ]

      secrets = var.env == "production" ? [] : [
        { name = "PERF_TEST_PHONE_NUMBER", valueFrom = aws_secretsmanager_secret_version.perf_test_phone_number[0].arn },
        { name = "PERF_TEST_EMAIL_ADDRESS", valueFrom = aws_secretsmanager_secret_version.perf_test_email[0].arn },
        { name = "PERF_TEST_DOMAIN", valueFrom = aws_secretsmanager_secret_version.perf_test_domain[0].arn },
        { name = "PERF_TEST_API_KEY", valueFrom = aws_secretsmanager_secret_version.perf_test_api_key[0].arn },
        { name = "PERF_TEST_SLACK_WEBHOOK", valueFrom = aws_secretsmanager_secret_version.perf_test_slack_webhook[0].arn },
        { name = "DATABASE_READER_URI", valueFrom = aws_secretsmanager_secret_version.perf_test_database_uri[0].arn },
        { name = "PERF_TEST_WAF_SECRET", valueFrom = var.manifests_waf_secret },
      ]
    }
  ])

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}
