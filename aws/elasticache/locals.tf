locals {
  # In Staging we add a Redis cluster specific security group for things like the lambda admin PR review env
  cluster_security_group_ids = var.env == "staging" ? [var.eks_cluster_securitygroup, aws_security_group.redis_cluster[0].id] : [var.eks_cluster_securitygroup]
}
