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
