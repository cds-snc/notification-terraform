variable "cloudwatch_opsgenie_alarm_webhook" {
  description = "OpsGenie webhook used to trigger a page when there is a critical alarm."
  type        = string
  sensitive   = true
}

variable "cloudwatch_slack_webhook_critical_topic" {
  description = "Slack webhook used to post critical alarm notifications."
  type        = string
  sensitive   = true
}

variable "cloudwatch_slack_webhook_warning_topic" {
  description = "Slack webhook used to post warning alarm notifications."
  type        = string
  sensitive   = true
}

variable "cloudwatch_slack_webhook_general_topic" {
  description = "Slack webhook used to post general alarm notifications."
  type        = string
  sensitive   = true
}

variable "slack_channel_critical_topic" {
  type = string
}

variable "slack_channel_warning_topic" {
  type = string
}

variable "slack_channel_general_topic" {
  type = string
}

variable "sns_monthly_spend_limit" {
  type = number
}

variable "sns_monthly_spend_limit_us_west_2" {
  type = number
}

variable "lambda_ses_receiving_emails_name" {
  type    = string
  default = "ses-receiving-emails"
}

variable "celery_queue_prefix" {
  type = string
  # Matches the env NOTIFICATION_QUEUE_PREFIX
  # in https://github.com/cds-snc/notification-manifests/blob/main/base/api-deployment.yaml
  default = "eks-notification-canada-ca"
}

variable "sqs_sms_queue_name" {
  type = string
  # See QueueNames in
  # https://github.com/cds-snc/notification-api/blob/master/app/config.py
  default = "send-sms-tasks"
}

variable "sqs_throttled_sms_queue_name" {
  type = string
  # See QueueNames in
  # https://github.com/cds-snc/notification-api/blob/master/app/config.py
  default = "send-throttled-sms-tasks"
}

variable "sqs_db_tasks_queue_name" {
  type = string
  # See QueueNames in
  # https://github.com/cds-snc/notification-api/blob/master/app/config.py
  default = "database-tasks"
}

variable "sqs_priority_db_tasks_queue_name" {
  type = string
}

variable "sqs_normal_db_tasks_queue_name" {
  type = string
}

variable "sqs_bulk_db_tasks_queue_name" {
  type = string
}

variable "alarm_warning_document_download_bucket_size_gb" {
  type = number
}

variable "alarm_warning_inflight_processed_created_delta_threshold" {
  description = "Warning alarm threshold for the difference between processed and created inflights"
  type        = number
}

variable "alarm_critical_inflight_processed_created_delta_threshold" {
  description = "Critical alarm threshold for the difference between processed and created inflights"
  type        = number
}

variable "alarm_warning_priority_inflight_processed_created_delta_threshold" {
  description = "Warning alarm threshold for the difference between processed and created priority inflights"
  type        = number
}

variable "alarm_critical_priority_inflight_processed_created_delta_threshold" {
  description = "Critical alarm threshold for the difference between processed and created priority inflights"
  type        = number
}

variable "alarm_warning_normal_inflight_processed_created_delta_threshold" {
  description = "Warning alarm threshold for the difference between processed and created priority inflights"
  type        = number
}

variable "alarm_critical_normal_inflight_processed_created_delta_threshold" {
  description = "Critical alarm threshold for the difference between processed and created priority inflights"
  type        = number
}

variable "alarm_warning_bulk_inflight_processed_created_delta_threshold" {
  description = "Warning alarm threshold for the difference between processed and created priority inflights"
  type        = number
}

variable "alarm_critical_bulk_inflight_processed_created_delta_threshold" {
  description = "Critical alarm threshold for the difference between processed and created priority inflights"
  type        = number
}

variable "alarm_warning_bulk_processed_created_delta_threshold" {
  description = "Warning alarm threshold for the difference between processed and created bulk sends"
  type        = number
}

variable "alarm_critical_bulk_processed_created_delta_threshold" {
  description = "Critical alarm threshold for the difference between processed and created bulk sends"
  type        = number
}
