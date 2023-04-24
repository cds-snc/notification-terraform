resource "aws_sqs_queue" "priority_db_tasks_queue" {
  name                    = "${var.celery_queue_prefix}-${var.sqs_priority_db_tasks_queue_name}"
  fifo_queue              = true
  deduplication_scope     = "messageGroup"
  fifo_throughput_limit   = "perMessageGroupId"
  sqs_managed_sse_enabled = true
  # tfsec:ignore:AWS015 - Queues should be encrypted with customer managed KMS keys
  # AWS managed encryption is good enough for us
}

resource "aws_sqs_queue" "normal_db_tasks_queue" {
  name                    = "${var.celery_queue_prefix}-${var.sqs_normal_db_tasks_queue_name}"
  sqs_managed_sse_enabled = true
  # tfsec:ignore:AWS015 - Queues should be encrypted with customer managed KMS keys
  # AWS managed encryption is good enough for us
}

resource "aws_sqs_queue" "bulk_db_tasks_queue" {
  name                    = "${var.celery_queue_prefix}-${var.sqs_bulk_db_tasks_queue_name}"
  sqs_managed_sse_enabled = true
  # tfsec:ignore:AWS015 - Queues should be encrypted with customer managed KMS keys
  # AWS managed encryption is good enough for us
}

resource "aws_sqs_queue" "notify_internal_tasks_queue" {
  name = "${var.celery_queue_prefix}notify-internal-tasks"
  # This queue was created outside of terraform and has this value set to false in staging and production.
  sqs_managed_sse_enabled = false
  # This queue was created outside of terraform and has this value set to 310 in staging and production.
  visibility_timeout_seconds = 310
}

