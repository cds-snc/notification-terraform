variable "aws_acm_notification_canada_ca_arn" {
  type = string
}

variable "aws_acm_alt_notification_canada_ca_arn" {
  type = string
}

variable "primary_worker_desired_size" {
  type = number
}

variable "primary_worker_instance_types" {
  type = list(any)
}

variable "primary_worker_max_size" {
  type = number
}

variable "primary_worker_min_size" {
  type = number
}

variable "vpc_id" {
  type = string
}

variable "vpc_private_subnets" {
  type = list(any)
}

variable "vpc_public_subnets" {
  type = list(any)
}

variable "sns_alert_warning_arn" {
  type = string
}

variable "sns_alert_critical_arn" {
  type = string
}

variable "sns_alert_general_arn" {
  type = string
}

variable "cloudfront_assets_arn" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

locals {
  eks_application_log_group = "/aws/containerinsights/${var.eks_cluster_name}/application"
}
