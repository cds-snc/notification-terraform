variable "eks_cluster_securitygroup" {
  type = string
}

variable "elasticache_node_type" {
  type = string
}

variable "vpc_private_subnets" {
  type = list(any)
}
