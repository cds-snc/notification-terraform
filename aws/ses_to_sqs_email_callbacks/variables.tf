variable "billing_tag_value" {
  type        = string
  description = "Identifies the billing code."
}

variable "notify_sending_domain" {
  sensitive   = true
  type        = string
  description = "Sending domain for notify."
}

variable "sqs_region" {
  type        = string
  description = "SQS region"
}

variable "celery_queue_prefix" {
  type        = string
  description = "Celery queue prefix"
}

variable "gc_notify_service_email" {
  type        = string
  description = "Sevice email for GC Notify."
}

variable "schedule_expression" {
  type        = string
  description = "This aws cloudwatch event rule scheule expression that specifies when the scheduler runs."
}

variable "sns_alert_warning_arn" {
  type = string
}

variable "sns_alert_critical_arn" {
  type = string
}
