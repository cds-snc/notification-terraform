variable "csv_upload_bucket_arn" {
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

variable "eks_application_log_group" {
  description = "log group of the k8s cluster applications"
  type        = string
}

variable "api_lambda_ecr_arn" {
  type        = string
  description = "ARN of Lambda ECR from ECR TF folder"
}

variable "api_lambda_ecr_repository_url" {
  type        = string
  description = "Docker Repo URL for API Lambda from ECR TF Folder"
}

variable "database_read_only_proxy_endpoint" {
  type        = string
  description = "Base read only endpoint for rds proxy"
}

variable "database_read_write_proxy_endpoint" {
  type        = string
  description = "Base read write endpoint for rds proxy"
}

variable "alb_arn_suffix" {
  type        = string
  description = "Suffix of the EKS ALB ARN. Used for dashboards."
}
