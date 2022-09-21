variable "admin_base_url" {
  type = string
}

variable "api_domain_name" {
  type = string
}

variable "api_lambda_domain_name" {
  type = string
}

variable "csv_upload_bucket_arn" {
  type = string
}

variable "new_relic_app_name" {
  type = string
}

variable "new_relic_distribution_tracing_enabled" {
  type = string
}

variable "new_relic_license_key" {
  type      = string
  sensitive = true
}

variable "notification_queue_prefix" {
  type = string
}

variable "redis_enabled" {
  type = string
}

variable "sqlalchemy_database_reader_uri" {
  type      = string
  sensitive = true
}

variable "sqlalchemy_database_uri" {
  type      = string
  sensitive = true
}

variable "vpc_private_subnets" {
  type = list(any)
}

variable "eks_cluster_securitygroup" {
  type = string
}

variable "firehose_waf_logs_iam_role_arn" {
  type = string
}

variable "document_download_api_host" {
  type = string
}

variable "api_image_tag" {
  type = string
}

variable "low_demand_min_concurrency" {
  type = number
}

variable "low_demand_max_concurrency" {
  type = number
}

variable "high_demand_min_concurrency" {
  type = number
}

variable "high_demand_max_concurrency" {
  type = number
}

variable "certificate_arn" {
  type = string
}

variable "sns_alert_warning_arn" {
  type = string
}

variable "sns_alert_critical_arn" {
  type = string
}

locals {
  api_lambda_log_group = "/aws/lambda/api-lambda"
}

variable "new_relic_account_id" {
  type = string
}

variable "ff_cloudwatch_metrics_enabled" {
  type = bool
}

variable "ip_blocklist_arn" {
  description = "Block all the IPs on this list from accessing admin and api"
  type        = string
}

variable "waf_secret" {
  description = "secret the admin sends in the header so the WAF does not rate limit"
  type        = string
  sensitive   = true
}
