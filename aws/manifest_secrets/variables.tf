variable "database_read_write_proxy_endpoint" {
  type = string
}

variable "database_read_only_proxy_endpoint" {
  type = string
}

variable "postgres_cluster_endpoint" {
  type = string
}

variable "redis_primary_endpoint_address" {
  type = string
}

variable "elasticache_queue_cache_primary_endpoint_address" {
  default = "changeme"
  type    = string
}

variable "signoz_smtp_username" {
  default   = "changeme"
  sensitive = true
}

variable "signoz_smtp_password" {
  default   = "changeme"
  sensitive = true
}

variable "manifest_signoz_postgres_password" {
  default   = "changeme"
  sensitive = true
}

variable "manifest_signoz_dashboard_api_key" {
  default   = "changeme"
  sensitive = true
}
