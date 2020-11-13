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

output "eks-cluster-securitygroup" {
  value = aws_eks_cluster.notification-canada-ca-eks-cluster.vpc_config[0].cluster_security_group_id
}