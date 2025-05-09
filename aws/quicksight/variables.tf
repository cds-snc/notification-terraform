locals {
  dataset_viewer_permissions = [
    "quicksight:DescribeDataSet",
    "quicksight:DescribeDataSetPermissions",
    "quicksight:DescribeIngestion",
    "quicksight:ListIngestions",
    "quicksight:PassDataSet"
  ]
  dataset_owner_permissions = concat(
    local.dataset_viewer_permissions,
    [
      "quicksight:DeleteDataSet",
      "quicksight:UpdateDataSet",
      "quicksight:UpdateDataSetPermissions",
      "quicksight:CreateIngestion",
      "quicksight:CancelIngestion"
  ])
}

variable "rds_reader_instance_id" {
  description = "The ID of the RDS reader instance to use for QuickSight"
  type        = string
}

variable "database_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "s3_bucket_sms_usage_sanitized_ca_central_id" {
  type = string
}

variable "s3_bucket_sms_usage_sanitized_us_west_id" {
  type = string
}

variable "sns_alert_warning_arn" {
  type = string
}

variable "database_subnet_ids" {
  type = list(string)
}

variable "quicksight_security_group_id" {
  type = string
}
