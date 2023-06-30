locals {
  quicksight_user_name = "quicksight_db_user"
}

variable "database_name" {
  type = string
}

variable "quicksight_user_password" {
  type      = string
  sensitive = true
}

variable "vpc_private_subnets" {
  type = list(any)
}

variable "sns_alert_general_arn" {
  type = string
}
