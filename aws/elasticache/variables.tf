variable "eks_cluster_securitygroup" {
  type = string
}

variable "elasticache_node_count" {
  type    = number
  default = 1
}

variable "elasticache_node_number_cache_clusters" {
  description = "defines the total number of nodes in a cluster"
  type        = number
  default     = 3
}

variable "elasticache_node_type" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_private_subnets" {
  type = list(any)
}

variable "sns_alert_warning_arn" {
  type = string
}

variable "sns_alert_critical_arn" {
  type = string
}

variable "kms_arn" {
  type = string
}