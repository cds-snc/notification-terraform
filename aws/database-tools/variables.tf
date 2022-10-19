variable "vpc_private_subnets" {
  type        = list(any)
  description = "List of the notify private subnets"
}

variable "vpc_id" {
  type        = string
  description = "Notify vpc id"
}

variable "billing_tag_value" {
  type        = string
  description = "Identifies the billing code."
}

variable "billing_tag_key" {
  type        = string
  description = "Identifies the billing key"
}

variable "sqlalchemy_database_reader_uri" {
  type        = string
  sensitive   = true
  description = "PSQL connection to notify db"
}

variable "database-tools-securitygroup" {
  type        = string
  description = "Database tools security group ID"
}

## Variables for RDS

variable "eks_cluster_securitygroup" {
  type        = string
  description = "EKS cluster security group"
}

variable "kms_arn" {
  type = string
}

variable "dbtools_password" {
  type        = string
  sensitive   = true
  description = "Pass for database-tools psql db"
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
