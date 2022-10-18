variable "vpc_private_subnets" {
  type = list(any)
}

variable "vpc_id" {
  type = string
}

variable "billing_tag_value" {
  type        = string
  description = "Identifies the billing code."
}

variable "billing_tag_key" {
  type = string
}

variable "sqlalchemy_database_reader_uri" {
  type      = string
  sensitive = true
}

variable "database-tools-securitygroup" {
  type        = string
  sensitive   = true
  description = "Database tools security group ID"
}

## Variables for RDS

variable "eks_cluster_securitygroup" {
  type = string
}

variable "kms_arn" {
  type = string
}

variable "dbtools_password" {
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

variable "sns_alert_general_arn" {
  type = string
}
