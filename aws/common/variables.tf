variable "billing_tag_value" {
  type        = string
  description = "Identifies the billing code."
}

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

variable "celery_queue_prefix" {
  type = string
  # Matches the env NOTIFICATION_QUEUE_PREFIX
  # in https://github.com/cds-snc/notification-manifests/blob/main/base/api-deployment.yaml
  default = "eks-notification-canada-ca"
}

variable "sqs_visibility_timeout_default" {
  type = number
  # See SQS visibility timeout
  # https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-visibility-timeout.html
  default = 305
}

variable "sqs_visibility_timeout_priority_high" {
  type = number
  # See SQS visibility timeout
  # https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-visibility-timeout.html
  default = 26
}

variable "sqs_send_email_high_queue_name" {
  type = string
  # See QueueNames in
  # https://github.com/cds-snc/notification-api/blob/master/app/config.py
  default = "send-email-high"
}

variable "sqs_send_email_medium_queue_name" {
  type = string
  # See QueueNames in
  # https://github.com/cds-snc/notification-api/blob/master/app/config.py
  default = "send-email-medium"
}

variable "sqs_send_email_low_queue_name" {
  type = string
  # See QueueNames in
  # https://github.com/cds-snc/notification-api/blob/master/app/config.py
  default = "send-email-low"
}

variable "sqs_send_sms_high_queue_name" {
  type = string
  # See QueueNames in
  # https://github.com/cds-snc/notification-api/blob/master/app/config.py
  default = "send-sms-high"
}

variable "sqs_send_sms_medium_queue_name" {
  type = string
  # See QueueNames in
  # https://github.com/cds-snc/notification-api/blob/master/app/config.py
  default = "send-sms-medium"
}

variable "sqs_send_sms_low_queue_name" {
  type = string
  # See QueueNames in
  # https://github.com/cds-snc/notification-api/blob/master/app/config.py
  default = "send-sms-low"
}

variable "sqs_priority_queue_name" {
  type = string
  # See QueueNames in
  # https://github.com/cds-snc/notification-api/blob/master/app/config.py
  default = "priority-tasks"
}

variable "sqs_bulk_queue_name" {
  type = string
  # See QueueNames in
  # https://github.com/cds-snc/notification-api/blob/master/app/config.py
  default = "bulk-tasks"
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

variable "alarm_warning_priority_bulk_processed_created_delta_threshold" {
  description = "Warning alarm threshold for the difference between processed and created bulk sends"
  type        = number
}

variable "alarm_critical_priority_bulk_processed_created_delta_threshold" {
  description = "Critical alarm threshold for the difference between processed and created bulk sends"
  type        = number
}

variable "alarm_warning_normal_bulk_processed_created_delta_threshold" {
  description = "Warning alarm threshold for the difference between processed and created bulk sends"
  type        = number
}

variable "alarm_critical_normal_bulk_processed_created_delta_threshold" {
  description = "Critical alarm threshold for the difference between processed and created bulk sends"
  type        = number
}

variable "alarm_warning_bulk_bulk_processed_created_delta_threshold" {
  description = "Warning alarm threshold for the difference between processed and created bulk sends"
  type        = number
}

variable "alarm_critical_bulk_bulk_processed_created_delta_threshold" {
  description = "Critical alarm threshold for the difference between processed and created bulk sends"
  type        = number
}

variable "alarm_critical_expired_inflights_threshold" {
  description = "Critical alarm threshold for number of expired inflights in 5 minutes"
  type        = number
}

variable "alarm_warning_callback_failure_threshold" {
  description = "Warning alarm threshold for number of callback failures in 30 minutes"
  type        = number
}

variable "force_destroy_s3" {
  description = "Destroy S3 buckets even if there are files in them when running terraform destroy"
  type        = bool
  default     = false
}

variable "force_destroy_athena" {
  description = "Destroy Athena workgroups even if there are tables in them when running terraform destroy"
  type        = bool
  default     = false
}

variable "athena_workgroup_name" {
  description = "Set the name for the athena workgroup"
  type        = string
  default     = "primary"
}

variable "create_cbs_bucket" {
  description = "Create the CBS bucket. Useful if this is a scratch deployment."
  type        = bool
  default     = false
}

variable "eks_cluster_name" {
  description = "Name of EKS Cluster"
  type        = string
}

variable "account_budget_limit" {
  description = "The dollar amount in USD that this AWS account should be budgeted to"
  type        = number
  default     = 3000

}

variable "account_budget_alert_emails" {
  description = "List of people who should be alerted when budget thresholds are met"
  type        = list(any)
  default     = ["jimmy.royer@cds-snc.ca", "stephen.astels@cds-snc.ca", "ben.larabie@cds-snc.ca", "michael.pond@cds-snc.ca"]
}

variable "budget_sre_bot_webhook" {
  description = "Slack webhook used to post budget alerts to the SRE bot"
  type        = string
  sensitive   = true
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
