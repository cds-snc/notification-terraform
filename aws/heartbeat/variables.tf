variable "billing_tag_value" {
  type        = string
  description = "Identifies the billing code."
}

variable "heartbeat_api_key" {
  sensitive   = true
  type        = string
  description = "Identifies the heartbeat api key."
}

variable "base_domain" {
  sensitive   = true
  type        = string
  description = "Identifies the base url to trigger the heartbeat function with. This is a string in the secrets and parsed in the lambda"
}

variable "heartbeat_email_bulk_template_id" {
  type        = string
  description = "Identifies the bulk email template id used by the heartbeat lambda."
}

variable "heartbeat_email_normal_template_id" {
  type        = string
  description = "Identifies the normal email template id used by the heartbeat lambda."
}

variable "heartbeat_email_priority_template_id" {
  type        = string
  description = "Identifies the priority email template id used by the heartbeat lambda."
}

variable "heartbeat_sms_bulk_template_id" {
  type        = string
  description = "Identifies the bulk SMS template id used by the heartbeat lambda."
}

variable "heartbeat_sms_normal_template_id" {
  type        = string
  description = "Identifies the normal SMS template id used by the heartbeat lambda."
}

variable "heartbeat_sms_priority_template_id" {
  type        = string
  description = "Identifies the priority SMS template id used by the heartbeat lambda."
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
variable "heartbeat_ecr_arn" {
  type        = string
  description = "Inherited from ecr dependency"
}
variable "heartbeat_ecr_repository_url" {
  type        = string
  description = "Inherited from ecr dependency"
}
variable "heartbeat_docker_tag" {
  type        = string
  description = "Set this to specify the image version"
  default     = "bootstrap"
}
