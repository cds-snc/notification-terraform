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

variable "sqs_delivery_receipts_arn" {
  type = string
}
