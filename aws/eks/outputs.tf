###
# Target groups
###
output "api_target_group_arn" {
  value = aws_alb_target_group.notification-canada-ca-api.arn
}

output "admin_target_group_arn" {
  value = aws_alb_target_group.notification-canada-ca-admin.arn
}

output "document_target_group_arn" {
  value = aws_alb_target_group.notification-canada-ca-document.arn
}

output "document_api_target_group_arn" {
  value = aws_alb_target_group.notification-canada-ca-document-api.arn
}

output "documentation_target_group_arn" {
  value = aws_alb_target_group.notification-canada-ca-documentation.arn
}

###
# EKS cluster
###
output "eks-cluster-securitygroup" {
  value = aws_eks_cluster.notification-canada-ca-eks-cluster.vpc_config[0].cluster_security_group_id
}

output "eks_application_log_group" {
  value = local.eks_application_log_group
}

###
# Databasetools Security group
###
output "database-tools-securitygroup" {
  value       = aws_security_group.blazer.id
  description = "database tools security group id"
}

output "database-tools-db-securitygroup" {
  value       = aws_security_group.database-tools-db-securitygroup.id
  description = "database tools DATABASE security group id"
}

# Google cidr prefix list id
output "google_cidr_prefix_list_id" {
  value       = aws_ec2_managed_prefix_list.google_cidrs.id
  description = "Google CIDR managed prefix list ID"
}
