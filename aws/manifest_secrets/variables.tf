variable "database_read_write_proxy_endpoint" {
  type = string
}

variable "database_read_only_proxy_endpoint" {
  type = string
}

variable "postgres_rds_instance_id" {
  type = string
}

variable "postgres_cluster_endpoint" {
  type = string
}

variable "redis_primary_endpoint_address" {
  type = string
}
