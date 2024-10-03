variable "vpc_private_subnets" {
  type        = list(any)
  description = "List of the notify private subnets"
}

variable "vpc_id" {
  type        = string
  description = "Notify vpc id"
}

variable "billing_tag_value" {
  type        = string
  description = "Identifies the billing code."
}

variable "billing_tag_key" {
  type        = string
  description = "Identifies the billing key"
}

variable "blazer_image_tag" {
  type        = string
  description = "The Blazer Docker image tag to deploy"
}

variable "notify_o11y_google_oauth_client_id" {
  type        = string
  sensitive   = true
  description = "Google OAuth client ID for Notify observability tools"
}

variable "notify_o11y_google_oauth_client_secret" {
  type        = string
  sensitive   = true
  description = "Google OAuth client secret for Notify observability tools"
}

variable "base_domain" {
  type        = string
  description = "The URL of the Notify service for Blazer to connect to, given proper environment"
}

variable "database-tools-securitygroup" {
  type        = string
  description = "Database tools security group ID"
}

variable "database-tools-db-securitygroup" {
  type        = string
  description = "Security group for the DB within Database tool"
}

## Variables for RDS

variable "dbtools_password" {
  type        = string
  sensitive   = true
  description = "Pass for database-tools psql db"
}

variable "enable_delete_protection" {
  type        = bool
  description = "Sets whether or not to enable delete protection."
  default     = true
}

variable "database_read_only_proxy_endpoint" {
  type        = string
  description = "Base endpoint for rds proxy"
}
variable "app_db_user_password" {
  type        = string
  sensitive   = true
  description = "Password for app_db_user rds cluster"
}

variable "cloudwatch_slack_webhook_general_topic" {
  description = "Slack webhook used to post general alarm notifications."
  type        = string
  sensitive   = true
}

variable "sns_alert_warning_arn" {
  description = "value of the sns alert warning arn"
  type        = string
}

variable "bootstrap" {
  type        = bool
  description = "Set this to true to use the bootstrap image"
  default     = false
}

variable "force_delete_ecr" {
  description = "Whether to force delete the ECR repository"
  type        = bool
  default     = false
}

variable "rds_version" {
  description = "The version of the RDS instance"
  type        = string
  default     = "15.5"
}