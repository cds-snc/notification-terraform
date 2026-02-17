variable "vpc_id" {
  type = string
}

variable "vpc_private_subnets" {
  type = list(any)
}

variable "vpc_private_subnets_k8s" {
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

variable "firehose_waf_logs_iam_role_arn" {
  type = string
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

variable "re_admin_arn2" {
  description = "Regular expression (2) to match the admin urls"
  type        = string
}

variable "re_document_download_arn" {
  description = "Regular expression to match the document download api urls"
  type        = string
}

variable "re_documentation_arn" {
  description = "Regular expression to match the documentation website"
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

variable "notification_base_url_regex_arn" {
  type        = string
  description = "The ARN of the regex for the notify base URL"
}

variable "internal_dns_certificate_arn" {
  type        = string
  description = "The ARN for the internal DNS certificate"
}

variable "internal_dns_zone_id" {
  type        = string
  description = "The zone id for the internal DNS"
}

variable "internal_dns_name" {
  type        = string
  description = "The fqdn for the internal DNS"
}

variable "subnet_cidr_blocks" {
  type        = list(string)
  description = "The CIDR blocks for the subnets"
}

variable "subnet_ids" {
  type        = list(string)
  description = "The IDs for the subnets"
}

variable "security_txt_content" {
  type        = string
  description = "The content of the security.txt file"
}