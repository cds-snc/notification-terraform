variable "primary_worker_desired_size" {
  type = number
}

variable "primary_worker_instance_types" {
  type = list(any)
}

variable "secondary_worker_instance_types" {
  type = list(any)
}

variable "node_upgrade" {
  type        = bool
  description = "Set to true when wanting to upgrade Node sizes"
  default     = false
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

variable "notify_k8s_namespace" {
  type        = string
  description = "Kubernetes namespace where GC Notify is installed"
  default     = "notification-canada-ca"
}

variable "route_53_zone_arn" {
  type        = string
  description = "Used by the scratch environment to reference cdssandbox in staging"
  default     = "/hostedzone/Z04028033PLSHVOO9ZJ1Z"
}

variable "enable_delete_protection" {
  type        = bool
  description = "Flag to enable or disable delete protection on resources."
  default     = true
}

variable "notification_base_url_regex_arn" {
  type        = string
  description = "The ARN of the regex for the notify base URL"
}

variable "sqs_send_email_high_queue_name" {
  type = string
  # See QueueNames in
  # https://github.com/cds-snc/notification-api/blob/master/app/config.py
  default = "send-email-high"
}

variable "sqs_send_email_medium_queue_name" {
  type = string
  # See QueueNames in
  # https://github.com/cds-snc/notification-api/blob/master/app/config.py
  default = "send-email-medium"
}

variable "sqs_send_email_low_queue_name" {
  type = string
  # See QueueNames in
  # https://github.com/cds-snc/notification-api/blob/master/app/config.py
  default = "send-email-low"
}

variable "sqs_send_sms_high_queue_name" {
  type = string
  # See QueueNames in
  # https://github.com/cds-snc/notification-api/blob/master/app/config.py
  default = "send-sms-high"
}

variable "sqs_send_sms_medium_queue_name" {
  type = string
  # See QueueNames in
  # https://github.com/cds-snc/notification-api/blob/master/app/config.py
  default = "send-sms-medium"
}

variable "sqs_send_sms_low_queue_name" {
  type = string
  # See QueueNames in
  # https://github.com/cds-snc/notification-api/blob/master/app/config.py
  default = "send-sms-low"
}

variable "celery_queue_prefix" {
  type        = string
  description = "Celery queue prefix"
}

variable "eks_addon_ebs_driver_version" {
  type        = string
  description = "Version for EBS driver addon for EKS (Persistence)"
}

variable "force_upgrade" {
  type        = bool
  description = "Force k8s upgrade even though not all pods were able to be evicted"
  default     = false
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

variable "pr_bot_private_key" {
  type        = string
  description = "The Private Key for PR Bot, used by Github ARC"
  sensitive   = true
}

variable "pr_bot_app_id" {
  type        = string
  description = "The AppID for PR Bot, used by Github ARC"
  sensitive   = true
}

variable "pr_bot_installation_id" {
  type        = string
  description = "The installation ID for PR Bot, used by Github ARC"
  sensitive   = true
}

variable "base_domain" {
  type        = string
  description = "The base domain for the environment"
}

variable "client_vpn_self_service_saml_metadata" {
  type        = string
  description = "The SAML metadata for the client VPN self service"
}

variable "client_vpn_saml_metadata" {
  type        = string
  description = "The SAML metadata for the client VPN"
}

variable "client_vpn_access_group_id" {
  type        = string
  description = "The access group ID for the client VPN"
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_blocks" {
  type        = list(string)
  description = "The CIDR blocks for the subnets"
}

variable "subnet_ids" {
  type        = list(string)
  description = "The IDs for the subnets"
}

variable "eks_karpenter_ami_id" {
  type        = string
  description = "The AMI ID for the Karpenter nodes"
}
