#
# ECS Fargate cluster
#

resource "aws_ecs_cluster" "perf_test" {
  name = "performance_test_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    base              = 1
  }

  lifecycle {
    ignore_changes = [setting]
  }

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}

#
# Task
#

data "template_file" "perf_test_container_definition" {
  template = file("container_definitions/perf_test.json.tmpl")

  vars = {
    AWS_LOGS_GROUP         = aws_cloudwatch_log_group.perf_test_ecs_logs.name
    AWS_LOGS_REGION        = var.region
    AWS_LOGS_STREAM_PREFIX = "${aws_ecs_cluster.perf_test.name}-task"
    ECR_REPOSITORY_URL     = var.performance_test_ecr_repository_url

    PERF_TEST_AWS_S3_BUCKET                     = var.perf_test_aws_s3_bucket
    PERF_TEST_CSV_DIRECTORY_PATH                = var.perf_test_csv_directory_path
    PERF_TEST_SMS_TEMPLATE_ID                   = var.perf_test_sms_template_id
    PERF_TEST_BULK_EMAIL_TEMPLATE_ID            = var.perf_test_bulk_email_template_id
    PERF_TEST_EMAIL_TEMPLATE_ID                 = var.perf_test_email_template_id
    PERF_TEST_EMAIL_WITH_ATTACHMENT_TEMPLATE_ID = var.perf_test_email_with_attachment_template_id
    PERF_TEST_EMAIL_WITH_LINK_TEMPLATE_ID       = var.perf_test_email_with_link_template_id

    PERF_TEST_PHONE_NUMBER_ARN = var.env == "production" ? "" : aws_secretsmanager_secret_version.perf_test_phone_number[0].arn
    PERF_TEST_EMAIL_ARN        = var.env == "production" ? "" : aws_secretsmanager_secret_version.perf_test_email[0].arn
    PERF_TEST_DOMAIN_ARN       = var.env == "production" ? "" : aws_secretsmanager_secret_version.perf_test_domain[0].arn
    PERF_TEST_AUTH_HEADER_ARN  = var.env == "production" ? "" : aws_secretsmanager_secret_version.perf_test_auth_header[0].arn
  }
}

resource "aws_ecs_task_definition" "perf_test_task" {
  family                   = aws_ecs_cluster.perf_test.name
  cpu                      = 2048
  memory                   = 4096
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.container_execution_role.arn
  task_role_arn            = aws_iam_role.perf_test_ecs_task.arn
  container_definitions    = data.template_file.perf_test_container_definition.rendered

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}
