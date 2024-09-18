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
