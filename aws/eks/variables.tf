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

variable "eks_cluster_version" {
  description = "Kubernetes version of the cluster"
  type        = string
}

variable "firehose_waf_logs_iam_role_arn" {
  type = string
}

variable "eks_node_ami_version" {
  description = "The Amazon Machine Image version used by the EKS EC2 nodes" # https://docs.aws.amazon.com/eks/latest/userguide/eks-linux-ami-versions.html
  type        = string
}

locals {
  eks_application_log_group = "/aws/containerinsights/${var.eks_cluster_name}/application"
}
