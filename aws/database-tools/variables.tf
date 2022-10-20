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

variable "database-tools-db-securitygroup" {
  type        = string
  description = "Security group for the DB within Database tool"
}

## Variables for RDS

variable "dbtools_password" {
  type        = string
  sensitive   = true
  description = "Pass for database-tools psql db"
}
