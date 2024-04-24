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

variable "bootstrap" {
  type    = bool
  default = false
}

variable "rds_instance_id" {
  type = string
}

variable "database_name" {
  type = string
}

variable "quicksight_db_user_name" {
  type    = string
  default = "quicksight_db_user"
}

variable "quicksight_db_user_password" {
  type      = string
  sensitive = true
}

variable "vpc_private_subnets" {
  type = list(any)
}

variable "vpc_id" {
  type = string
}

variable "s3_bucket_sms_usage_id" {
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

variable "database_read_write_proxy_endpoint" {
  type = string
}

variable "database_read_write_proxy_endpoint_host" {
  type = string
}

variable "rds_cluster_password" {
  type      = string
  sensitive = true
}