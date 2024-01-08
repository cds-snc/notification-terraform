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
  # This queue was created outside of terraform and has this value set to default in staging and production.
  visibility_timeout_seconds = var.sqs_visibility_timeout_default
}

resource "aws_sqs_queue" "eks_notification_canada_ca_sms_high_queue" {
  name                    = "${var.celery_queue_prefix}send-sms-high"
  sqs_managed_sse_enabled = true
  # tfsec:ignore:AWS015 - Queues should be encrypted with customer managed KMS keys
  # AWS managed encryption is good enough for us

  # Visibility timeout is set to 26 seconds for an application side retry set to 25 seconds.
  visibility_timeout_seconds = var.sqs_visibility_timeout_priority_high
}

resource "aws_sqs_queue" "eks_notification_canada_ca_email_high_queue" {
  name                    = "${var.celery_queue_prefix}send-email-high"
  sqs_managed_sse_enabled = true
  # tfsec:ignore:AWS015 - Queues should be encrypted with customer managed KMS keys
  # AWS managed encryption is good enough for us

  # Visibility timeout is set to 26 seconds for an application side retry set to 25 seconds.
  visibility_timeout_seconds = var.sqs_visibility_timeout_priority_high
}

resource "aws_sqs_queue" "eks_notification_canada_cadelivery_receipts" {
  name             = "eks-notification-canada-cadelivery-receipts"
  delay_seconds    = 0
  max_message_size = 262144
  #4 Days
  message_retention_seconds  = 345600
  receive_wait_time_seconds  = 0
  visibility_timeout_seconds = var.sqs_visibility_timeout_default

  tags = {
    Environment = var.env
  }
}
