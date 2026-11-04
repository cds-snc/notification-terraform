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

variable "signoz_postgres_password" {
  default   = "changeme"
  sensitive = true
}

variable "signoz_dashboard_api_key" {
  default   = "changeme"
  sensitive = true
}

variable "enable_signoz_weekly_report" {
  description = "Create weekly reporting secrets after Notify has been bootstrapped."
  type        = bool
  default     = false

  validation {
    condition = !var.enable_signoz_weekly_report || alltrue([
      for value in [
        var.signoz_report_notify_api_key,
        var.signoz_report_email,
        var.signoz_report_password,
      ] : try(length(trimspace(value)) > 0, false)
    ])
    error_message = "When enable_signoz_weekly_report is true, signoz_report_notify_api_key, signoz_report_email, and signoz_report_password must all be nonempty."
  }
}

variable "signoz_report_notify_api_key" {
  type      = string
  sensitive = true
  default   = null
}

variable "signoz_report_email" {
  type      = string
  sensitive = true
  default   = null
}

variable "signoz_report_password" {
  type      = string
  sensitive = true
  default   = null
}
