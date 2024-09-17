variable "csv_upload_bucket_arn" {
  type = string
}

variable "new_relic_license_key" {
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

variable "base_domain" {
  type = string
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

variable "ip_blocklist_arn" {
  description = "Block all the IPs on this list from accessing admin and api"
  type        = string
}

variable "re_api_arn" {
  description = "Regular expression to match the api urls"
  type        = string
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

variable "route53_zone_id" {
  type        = string
  description = "Used by the scratch environment to reference cdssandbox in staging"
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

variable "database_read_only_proxy_endpoint" {
  type        = string
  description = "Base read only endpoint for rds proxy"
}

variable "database_read_write_proxy_endpoint" {
  type        = string
  description = "Base read write endpoint for rds proxy"
}

variable "app_db_user_password" {
  type        = string
  sensitive   = true
  description = "Password for rds cluster"
}

variable "alb_arn_suffix" {
  type        = string
  description = "Suffix of the EKS ALB ARN. Used for dashboards."
}
