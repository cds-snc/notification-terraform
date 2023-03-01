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

variable "eks_addon_coredns_version" {
  description = "CoreDNS EKS addon version"
  type        = string
}

variable "eks_addon_kube_proxy_version" {
  description = "kube-proxy EKS addon version"
  type        = string
}

variable "eks_addon_vpc_cni_version" {
  description = "VPC-CNI EKS addon version"
  type        = string
}

variable "firehose_waf_logs_iam_role_arn" {
  type = string
}

variable "eks_node_ami_version" {
  description = "The Amazon Machine Image version used by the EKS EC2 nodes" # https://docs.aws.amazon.com/eks/latest/userguide/eks-linux-ami-versions.html
  type        = string
}

variable "non_api_waf_rate_limit" {
  description = "Fall back rate limit for everything except api and document download api"
  type        = number
}

variable "api_waf_rate_limit" {
  description = "Fall back rate limit for api and document download api"
  type        = number
}

variable "sign_in_waf_rate_limit" {
  description = "Rate limit for /register, /sigh-in, and /forgot-password"
  type        = number
}

variable "waf_secret" {
  description = "secret the admin sends in the header so the WAF does not rate limit"
  type        = string
  sensitive   = true
}

locals {
  eks_application_log_group = "/aws/containerinsights/${var.eks_cluster_name}/application"
}

variable "ip_blocklist_arn" {
  description = "Block all the IPs on this list from accessing admin and api"
  type        = string
}

variable "re_api_arn" {
  description = "Regular expression to match the api urls"
  type        = string
}

variable "re_admin_arn" {
  description = "Regular expression to match the admin urls"
  type        = string
}

variable "re_document_download_arn" {
  description = "Regular expression to match the document download api urls"
  type        = string
}

variable "private-links-vpc-endpoints-securitygroup" {
  type        = string
  description = "Security group for vpc endpoints to enable private link"
}

variable "private-links-gateway-prefix-list-ids" {
  type        = list(any)
  description = "private links gateway"
}

variable "sentinel_customer_id" {
  type        = string
  description = "sentinel customer id"
  sensitive   = true
}

variable "sentinel_shared_key" {
  type        = string
  description = "sentinel shared key"
  sensitive   = true
}

