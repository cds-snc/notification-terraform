variable "eks_cluster_securitygroup" {
  type = string
}

variable "kms_arn" {
  type = string
}

variable "rds_cluster_password" {
  type      = string
  sensitive = true
}

variable "app_db_user_password" {
  type      = string
  sensitive = true
}

variable "rds_instance_count" {
  type    = number
  default = 1
}

variable "rds_instance_type" {
  type = string
}

variable "vpc_private_subnets" {
  type = list(any)
}

variable "sns_alert_general_arn" {
  type = string
}

variable "enable_delete_protection" {
  type        = bool
  description = "Sets whether or not to enable delete protection."
  default     = true
}