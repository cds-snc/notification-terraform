variable "vpc_private_subnets" {
  type = list(any)
}

variable "vpc_id" {
  type = string
}

variable "sqlalchemy_database_reader_uri" {
  type      = string
  sensitive = true
}
