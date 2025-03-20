variable "eks_cluster_securitygroup" {
  type = string
}

variable "kms_arn" {
  type = string
}

variable "vpc_private_subnets" {
  type = list(any)
}

variable "sns_alert_general_arn" {
  type = string
}

variable "sentinel_forwarder_cloudwatch_lambda_name" {
  type        = string
  description = "Name of the Sentinel forwarder lambda function."
}

variable "sentinel_forwarder_cloudwatch_lambda_arn" {
  type        = string
  description = "ARN of the Sentinel forwarder lambda function."
}

variable "sns_alert_warning_arn" {
  type = string
}

variable "sns_alert_critical_arn" {
  type = string
}

variable "platform_data_lake_kms_key_arn" {
  type        = string
  description = "Platform Data Lake KMS key ARN used for encrypting RDS snapshot exports"
}

variable "platform_data_lake_raw_s3_bucket_arn" {
  type        = string
  description = "Platform Data Lake Raw S3 bucket ARN where RDS snapshots are exported"
}

variable "platform_data_lake_rds_export_role_arn" {
  type        = string
  description = "The Platform Data Lake IAM role that triggers RDS snapshot exports to S3"
}
