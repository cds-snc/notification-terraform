variable "billing_tag_value" {
  type        = string
  description = "Identifies the billing code."
}

variable "system_status_api_key" {
  sensitive   = true
  type        = string
  description = "Identifies the system_status api key."
}

variable "system_status_github_key" {
  sensitive   = true
  type        = string
  description = "Key to git commit to the system status repo"
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

variable "system_status_ecr_arn" {
  type        = string
  description = "Inherited from ecr dependency"
}

variable "system_status_ecr_repository_url" {
  type        = string
  description = "Inherited from ecr dependency"
}

variable "system_status_docker_tag" {
  type        = string
  description = "Set this to specify the image version"
  default     = "bootstrap"
}

variable "app_db_user_password" {
  type        = string
  sensitive   = true
  description = "Password for rds cluster"
}

variable "database_read_only_proxy_endpoint" {
  type        = string
  description = "Base read only endpoint for rds proxy"
}

variable "eks_cluster_securitygroup" {
  type = string
}

variable "vpc_private_subnets" {
  type = list(any)
}
