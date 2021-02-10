variable "cloudwatch_opsgenie_alarm_webhook" {
  type = string
}

variable "cloudwatch_slack_webhook_critical_topic" {
  type = string
}

variable "cloudwatch_slack_webhook_warning_topic" {
  type = string
}

variable "cloudwatch_slack_webhook_general_topic" {
  type = string
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
