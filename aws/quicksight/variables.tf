locals {
  quicksight_db_user_name = "quicksight_db_user"
}

variable "cluster_identifier" {
  type = string
}

variable "database_name" {
  type = string
}

variable "quicksight_db_user_password" {
  type      = string
  sensitive = true
}

variable "vpc_private_subnets" {
  type = list(any)
}

variable "vpc_id" {
  type = string
}

variable "sns_alert_warning_arn" {
  type = string
}

variable "database_subnet_ids" {
  type = list(string)
}

variable "quicksight_security_group_id" {
  type = string
}
