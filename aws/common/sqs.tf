resource "aws_sqs_queue" "priority_db_tasks_queue" {
  name                              = "${var.celery_queue_prefix}-${var.sqs_priority_db_tasks_queue_name}"
  fifo_queue                        = true
  deduplication_scope               = "messageGroup"
  fifo_throughput_limit             = "perMessageGroupId"
  kms_master_key_id                 = local.sqs_kms_config.kms_master_key_id
  kms_data_key_reuse_period_seconds = local.sqs_kms_config.kms_data_key_reuse_period_seconds

  tags = local.sqs_common_tags
}

resource "aws_sqs_queue" "normal_db_tasks_queue" {
  name                              = "${var.celery_queue_prefix}-${var.sqs_normal_db_tasks_queue_name}"
  kms_master_key_id                 = local.sqs_kms_config.kms_master_key_id
  kms_data_key_reuse_period_seconds = local.sqs_kms_config.kms_data_key_reuse_period_seconds

  tags = local.sqs_common_tags
}

resource "aws_sqs_queue" "bulk_db_tasks_queue" {
  name                              = "${var.celery_queue_prefix}-${var.sqs_bulk_db_tasks_queue_name}"
  kms_master_key_id                 = local.sqs_kms_config.kms_master_key_id
  kms_data_key_reuse_period_seconds = local.sqs_kms_config.kms_data_key_reuse_period_seconds

  tags = local.sqs_common_tags
}

resource "aws_sqs_queue" "notify_internal_tasks_queue" {
  name = "${var.celery_queue_prefix}notify-internal-tasks"
  # Updated to use customer-managed KMS key for better security compliance
  kms_master_key_id                 = local.sqs_kms_config.kms_master_key_id
  kms_data_key_reuse_period_seconds = local.sqs_kms_config.kms_data_key_reuse_period_seconds
  # This queue was created outside of terraform and has this value set to default in staging and production.
  visibility_timeout_seconds = var.sqs_visibility_timeout_default

  tags = local.sqs_common_tags
}

resource "aws_sqs_queue" "eks_notification_canada_ca_sms_high_queue" {
  name                              = "${var.celery_queue_prefix}send-sms-high"
  kms_master_key_id                 = local.sqs_kms_config.kms_master_key_id
  kms_data_key_reuse_period_seconds = local.sqs_kms_config.kms_data_key_reuse_period_seconds

  # Visibility timeout is set to 26 seconds for an application side retry set to 25 seconds.
  visibility_timeout_seconds = var.sqs_visibility_timeout_priority_high

  tags = local.sqs_common_tags
}

resource "aws_sqs_queue" "eks_notification_canada_ca_email_high_queue" {
  name                              = "${var.celery_queue_prefix}send-email-high"
  kms_master_key_id                 = local.sqs_kms_config.kms_master_key_id
  kms_data_key_reuse_period_seconds = local.sqs_kms_config.kms_data_key_reuse_period_seconds

  # Visibility timeout is set to 26 seconds for an application side retry set to 25 seconds.
  visibility_timeout_seconds = var.sqs_visibility_timeout_priority_high

  tags = local.sqs_common_tags
}

resource "aws_sqs_queue" "eks_notification_canada_cadelivery_receipts" {
  name             = "eks-notification-canada-cadelivery-receipts"
  delay_seconds    = 0
  max_message_size = 262144
  #4 Days
  message_retention_seconds         = 345600
  receive_wait_time_seconds         = 0
  visibility_timeout_seconds        = var.sqs_visibility_timeout_default
  kms_master_key_id                 = local.sqs_kms_config.kms_master_key_id
  kms_data_key_reuse_period_seconds = local.sqs_kms_config.kms_data_key_reuse_period_seconds

  tags = local.sqs_common_tags_with_env
}

resource "aws_sqs_queue" "ses_receipt_callback_buffer" {
  name                              = "ses-receipt-callback-buffer"
  delay_seconds                     = 0
  max_message_size                  = 262144
  message_retention_seconds         = 345600
  receive_wait_time_seconds         = 0
  visibility_timeout_seconds        = var.sqs_visibility_timeout_default
  kms_master_key_id                 = local.sqs_kms_config.kms_master_key_id
  kms_data_key_reuse_period_seconds = local.sqs_kms_config.kms_data_key_reuse_period_seconds

  tags = local.sqs_common_tags_with_env
}