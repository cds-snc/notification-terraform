#
# ECS Fargate cluster
#
resource "aws_ecs_cluster" "perf_test" {
  name = "performanceTestCluster"

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
    # S3_UPLOADS_BUCKET            = aws_secretsmanager_secret_version.s3_uploads_bucket.arn
    # S3_UPLOADS_KEY               = aws_secretsmanager_secret_version.s3_uploads_key.arn
    # S3_UPLOADS_SECRET            = aws_secretsmanager_secret_version.s3_uploads_secret.arn

    AWS_LOGS_GROUP         = aws_cloudwatch_log_group.perf_test_ecs_logs.name
    AWS_LOGS_REGION        = var.region
    AWS_LOGS_STREAM_PREFIX = "${aws_ecs_cluster.perf_test.name}-task"
  }
}

resource "aws_ecs_task_definition" "perf_test_task" {
  family       = aws_ecs_cluster.perf_test.name
  cpu          = 2
  memory       = 512
  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.perf_test_ecs_task.arn
  task_role_arn            = aws_iam_role.perf_test_ecs_task.arn
  container_definitions    = data.template_file.perf_test_container_definition.rendered

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}
