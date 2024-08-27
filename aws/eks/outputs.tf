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

output "internal_nginx_target_group_arn" {
  value = aws_alb_target_group.internal_nginx_http.arn
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

output "aws_acm_notification_canada_ca_arn" {
  value       = aws_acm_certificate.notification-canada-ca.arn
  description = "Shared DNS certificate between lambda and k8s"
}

output "aws_acm_alt_notification_canada_ca_arn" {
  value       = var.alt_domain != "" ? aws_acm_certificate.notification-canada-ca-alt[0].arn : ""
  description = "Shared DNS certificate between lambda and k8s"
}

output "alb_arn_suffix" {
  value       = aws_alb.notification-canada-ca.arn_suffix
  description = "Suffix of the EKS ALB ARN. Used for dashboards."
}

# Karpenter
output "karpenter_iam_role_arn" {
  value       = module.iam_assumable_role_karpenter.iam_role_arn
  description = "ARN of Karpenter IAM Role for EKS."
}

output "eks_cluster_endpoint" {
  value = data.aws_eks_cluster.notify_cluster.endpoint
}

output "karpenter_instance_profile" {
  value = aws_iam_instance_profile.karpenter.name
}

# Quicksight
output "quicksight_security_group_id" {
  value = aws_security_group.quicksight.id
}

# Sentinel
output "sentinel_forwarder_cloudwatch_lambda_arn" {
  value = module.sentinel_forwarder.lambda_arn
}

output "sentinel_forwarder_cloudwatch_lambda_name" {
  value = module.sentinel_forwarder.lambda_name
}

# GHA VPN
output "gha_vpn_id" {
  value = module.gha_vpn.client_vpn_endpoint_id
}

output "gha_vpn_certificate" {
  sensitive = true
  value = tls_self_signed_cert.client_vpn.cert_pem
}

output "gha_vpn_key" {
  sensitive = true
  value = tls_private_key.client_vpn.private_key_pem
}