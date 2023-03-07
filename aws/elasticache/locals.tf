locals {
  # Lambda PR review env security group is only included in Staging
  cluster_security_group_ids = var.env == "staging" ? [var.eks_cluster_securitygroup, aws_security_group.lambda_admin_pr_review[0].id] : [var.eks_cluster_securitygroup]
}
