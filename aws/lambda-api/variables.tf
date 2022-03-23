variable "admin_client_secret" {
  type      = string
  sensitive = true
}

variable "admin_client_user_name" {
  type      = string
  sensitive = true
}

variable "asset_domain" {
  type = string
}

variable "asset_upload_bucket_name" {
  type = string
}

variable "auth_tokens" {
  type      = string
  sensitive = true
}

// check if this already exists
variable "aws_pinpoint_region" {
  type = string
}

variable "csv_upload_bucket_name" {
  type = string
}

variable "csv_upload_bucket_arn" {
  type = string
}

variable "dangerous_salt" {
  type      = string
  sensitive = true
}

variable "documents_bucket" {
  type = string
}

variable "mlwr_host" {
  type      = string
  sensitive = true
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

variable "new_relic_monitor_mode" {
  type = string
}

variable "notification_queue_prefix" {
  type = string
}

variable "redis_enabled" {
  type = string
}

variable "redis_url" {
  type = string
}

variable "secret_key" {
  type      = string
  sensitive = true
}

variable "sqlalchemy_database_reader_uri" {
  type      = string
  sensitive = true
}

variable "sqlalchemy_database_uri" {
  type      = string
  sensitive = true
}

variable "sqlalchemy_pool_size" {
  type = string
}

variable "vpc_private_subnets" {
  type = list(any)
}

variable "eks_cluster_securitygroup" {
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

variable "api_domain_name" {
  type = string
}

variable "api_lambda_domain_name" {
  type = string
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

variable "ff_batch_insertion" {
  type = bool
}

variable "ff_redis_batch_saving" {
  type = bool
}

variable "ff_cloudwatch_metrics_enabled" {
  type = bool
}

variable "ff_notification_celery_persistence" {
  type = bool
}
