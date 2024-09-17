variable "vpc_private_subnets" {
  type        = list(any)
  description = "List of the notify private subnets"
}

variable "vpc_id" {
  type        = string
  description = "Notify vpc id"
}

variable "database-tools-securitygroup" {
  type        = string
  description = "Database tools security group ID"
}

variable "database-tools-db-securitygroup" {
  type        = string
  description = "Security group for the DB within Database tool"
}

## Variables for RDS
variable "database_read_only_proxy_endpoint" {
  type        = string
  description = "Base endpoint for rds proxy"
}

variable "sns_alert_warning_arn" {
  description = "value of the sns alert warning arn"
  type        = string
}

variable "rds_version" {
  description = "The version of the RDS instance"
  type        = string
  default     = "15.5"
}