###
# ALB
###
output "alb_arn" {
  value = aws_alb_target_group.notification-canada-ca.arn
}

output "alb_arn_suffix" {
  value = aws_alb_target_group.notification-canada-ca.arn_suffix
}

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

output "api_target_group_arn_suffix" {
  value = aws_alb_target_group.notification-canada-ca-api.arn_suffix
}

output "admin_target_group_arn_suffix" {
  value = aws_alb_target_group.notification-canada-ca-admin.arn_suffix
}

output "document_target_group_arn_suffix" {
  value = aws_alb_target_group.notification-canada-ca-document.arn_suffix
}

output "document_api_target_group_arn_suffix" {
  value = aws_alb_target_group.notification-canada-ca-document-api.arn_suffix
}

###
# EKS cluster
###
output "eks-cluster-securitygroup" {
  value = aws_eks_cluster.notification-canada-ca-eks-cluster.vpc_config[0].cluster_security_group_id
}

###
# EKS cluster log group
###
output "eks_cluster_log_group_name" {
  value = cloudwatch_log_group.notification-canada-ca-eks-cluster-logs.name
}
