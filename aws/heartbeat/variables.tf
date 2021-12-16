variable "billing_tag_value" {
  type        = string
  description = "Identifies the billing code."
}

variable "heartbeat_api_key" {
  sensitive   = true
  type        = string
  description = "Identifies the heartbeat api key."
}

variable "heartbeat_base_url" {
  sensitive   = true
  type        = string
  description = "Identifies the base url to trigger the heartbeat function with. This is a string in the secrets and parsed in the lambda"
}

variable "heartbeat_template_id" {
  type        = string
  description = "Identifies the template id on the ."
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
