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
