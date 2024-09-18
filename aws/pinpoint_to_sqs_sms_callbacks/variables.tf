variable "sns_alert_warning_arn" {
  type = string
}

variable "sns_alert_critical_arn" {
  type = string
}

variable "sns_alert_ok_arn" {
  type = string
}

variable "sqs_deliver_receipts_queue_arn" {
  type        = string
  description = "The arn of the SQS queue for receipts processing celery tasks"
}

variable "pinpoint_to_sqs_sms_callbacks_docker_tag" {
  type        = string
  description = "Set this to specify the image version"
  default     = "bootstrap"
}

variable "pinpoint_to_sqs_sms_callbacks_ecr_repository_url" {
  type        = string
  description = "The URL of the ECR repository for the pinpoint_to_sqs_sms_callbacks image"
}

variable "pinpoint_to_sqs_sms_callbacks_ecr_arn" {
  type        = string
  description = "The ARN of the ECR repository for the pinpoint_to_sqs_sms_callbacks image"
}

variable "sms_monthly_spend_limit" {
  type        = number
  description = "The total monthly spending limit for SMS (SNS plus Pinpoint)"
}

variable "sqs_send_sms_high_queue_delay_warning_arn" {
  description = "ARN for the corresponding alarm"
  type        = string
}

variable "sqs_send_sms_high_queue_delay_critical_arn" {
  description = "ARN for the corresponding alarm"
  type        = string
}

variable "sqs_send_sms_medium_queue_delay_warning_arn" {
  description = "ARN for the corresponding alarm"
  type        = string
}

variable "sqs_send_sms_medium_queue_delay_critical_arn" {
  description = "ARN for the corresponding alarm"
  type        = string
}

variable "sqs_send_sms_low_queue_delay_warning_arn" {
  description = "ARN for the corresponding alarm"
  type        = string
}

variable "sqs_send_sms_low_queue_delay_critical_arn" {
  description = "ARN for the corresponding alarm"
  type        = string
}
