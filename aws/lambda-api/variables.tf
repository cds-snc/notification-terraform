variable "admin_base_url" {
  type = string
}

variable "api_domain_name" {
  type = string
}

variable "api_lambda_domain_name" {
  type = string
}

variable "api_lambda_alt_domain_name" {
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
  type    = string
  default = "bootstrap"
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

variable "certificate_alt_arn" {
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

variable "re_api_arn" {
  description = "Regular expression to match the api urls"
  type        = string
}

variable "api_waf_rate_limit" {
  description = "Fall back rate limit for api and document download api"
  type        = number
}

variable "waf_secret" {
  description = "secret the admin sends in the header so the WAF does not rate limit"
  type        = string
  sensitive   = true
}

variable "eks_application_log_group" {
  description = "log group of the k8s cluster applications"
  type        = string
}

variable "route_53_zone_arn" {
  type        = string
  description = "Used by the scratch environment to reference cdssandbox in staging"
  default     = "/hostedzone/Z04028033PLSHVOO9ZJ1Z"
}

variable "api_lambda_ecr_arn" {
  type        = string
  description = "ARN of Lambda ECR from ECR TF folder"
}

variable "api_lambda_ecr_repository_url" {
  type        = string
  description = "Docker Repo URL for API Lambda from ECR TF Folder"
}
variable "bootstrap" {
  description = "Boolean value to decide whether or not to build images"
  type        = bool
  default     = false
}

variable "api_enable_new_relic" {
  description = "Boolean value to decide whether or not new relic is enabled"
  type        = bool
  default     = true
}

variable "database_proxy_endpoint" {
  type        = string
  description = "Base endpoint for rds proxy"
}

variable "rds_cluster_password" {
  type        = string
  sensitive   = true
  description = "Password for rds cluster"
}