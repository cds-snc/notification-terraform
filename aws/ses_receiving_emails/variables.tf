variable "sns_alert_warning_arn_us_east_1" {
  type = string
}

variable "sns_alert_critical_arn_us_east_1" {
  type = string
}

variable "sns_alert_ok_arn_us_east_1" {
  type = string
}

variable "sqs_notify_internal_tasks_arn" {
  type = string
}

variable "ses_receiving_emails_ecr_repository_url" {
  type        = string
  description = "Inherited from ecr dependency"
}

variable "ses_receiving_emails_ecr_arn" {
  type        = string
  description = "Inherited from ecr dependency"
}
