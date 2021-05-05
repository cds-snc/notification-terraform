variable "eks_cluster_securitygroup" {
  type = string
}

variable "elasticache_node_count" {
  type    = number
  default = 1
}

variable "elasticache_node_type" {
  type = string
}

variable "vpc_private_subnets" {
  type = list(any)
}

variable "sns_alert_warning_arn" {
  type = string
}
