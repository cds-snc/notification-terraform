variable "billing_tag_value" {
  type        = string
  description = "Identifies the billing code."
}
variable "sns_alert_warning_arn" {
  type = string
}

variable "sns_alert_critical_arn" {
  type = string
}

variable "sns_alert_ok_arn" {
  type = string
}

variable "notification_canada_ca_ses_callback_arn" {
  type = string
}
variable "ses_to_sqs_callbacks_docker_tag" {
  type        = string
  description = "Set this to specify the image version"
  default     = "bootstrap"
}

variable "ses_to_sqs_email_callbacks_ecr_repository_url" {
  type        = string
  description = "Inherited from ecr dependency"
}
variable "ses_to_sqs_email_callbacks_ecr_arn" {
  type        = string
  description = "Inherited from ecr dependency"
}

variable "sqs_eks_notification_canada_cadelivery_receipts_arn" {
  type        = string
  description = "Inherited from common dependency - sqs queue arn"
}