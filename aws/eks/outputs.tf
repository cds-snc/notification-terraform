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

###
# Databasetools Security group
###
output "database-tools-securitygroup" {
  value       = aws_security_group.blazer.arn
  description = "database tools security group"
}

output "database-tools-db-securitygroup" {
  value       = aws_security_group.database-tools-db-securitygroup.arn
  description = "database tools DATABASE security group"
}
