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

# We are doing this here as it is required for ses_receiving_emails lambda
# That folder is configured to use us-east-1, but the below queue is in ca-central-1
data "aws_sqs_queue" "notify-internal-tasks" {
  name = "${var.celery_queue_prefix}notify-internal-tasks"
}
