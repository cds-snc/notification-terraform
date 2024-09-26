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

variable "heartbeat_sms_number" {
  type        = string
  description = "Identifies the sms number to send hearbeats to"
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

variable "bootstrap" {
  type        = bool
  description = "Set this to true to use the bootstrap image"
  default     = false

}

variable "critical_government_password" {
  type        = string
  description = "Identifies the critical government password."
}
