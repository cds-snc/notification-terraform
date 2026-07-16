resource "aws_secretsmanager_secret" "nginx_target_group_arn" {
  provider                = aws.core_services
  name                    = "NGINX_TARGET_GROUP_ARN"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "nginx_target_group_arn" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.nginx_target_group_arn.id
  secret_string = aws_alb_target_group.internal_nginx_http.arn
}

resource "aws_secretsmanager_secret" "pr_bot_app_id" {
  provider                = aws.core_services
  name                    = "PR_BOT_APP_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "pr_bot_app_id" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.pr_bot_app_id.id
  secret_string = var.pr_bot_app_id
}

resource "aws_secretsmanager_secret" "pr_bot_private_key" {
  provider                = aws.core_services
  name                    = "PR_BOT_PRIVATE_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "pr_bot_private_key" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.pr_bot_private_key.id
  secret_string = var.pr_bot_private_key
}

resource "aws_secretsmanager_secret" "pr_bot_installation_id" {
  provider                = aws.core_services
  name                    = "PR_BOT_INSTALLATION_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "pr_bot_installation_id" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.pr_bot_installation_id.id
  secret_string = var.pr_bot_installation_id
}

resource "aws_secretsmanager_secret" "base_domain" {
  provider                = aws.core_services
  name                    = "BASE_DOMAIN"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "base_domain" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.base_domain.id
  secret_string = var.base_domain
}

resource "aws_secretsmanager_secret" "aws_region" {
  provider                = aws.core_services
  name                    = "AWS_REGION"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "aws_region" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.aws_region.id
  secret_string = var.region
}

resource "aws_secretsmanager_secret" "admin_target_group_arn" {
  provider                = aws.core_services
  name                    = "ADMIN_TARGET_GROUP_ARN"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "admin_target_group_arn" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.admin_target_group_arn.id
  secret_string = aws_alb_target_group.notification-canada-ca-admin.arn
}

resource "aws_secretsmanager_secret" "api_target_group_arn" {
  provider                = aws.core_services
  name                    = "API_TARGET_GROUP_ARN"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "api_target_group_arn" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.api_target_group_arn.id
  secret_string = aws_alb_target_group.notification-canada-ca-api.arn
}

resource "aws_secretsmanager_secret" "documentation_target_group_arn" {
  provider                = aws.core_services
  name                    = "DOCUMENTATION_TARGET_GROUP_ARN"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "documentation_target_group_arn" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.documentation_target_group_arn.id
  secret_string = aws_alb_target_group.notification-canada-ca-documentation.arn
}

resource "aws_secretsmanager_secret" "document_download_api_target_group_arn" {
  provider                = aws.core_services
  name                    = "DOCUMENT_DOWNLOAD_API_TARGET_GROUP_ARN"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "document_download_api_target_group_arn" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.document_download_api_target_group_arn.id
  secret_string = aws_alb_target_group.notification-canada-ca-document-api.arn
}

resource "aws_secretsmanager_secret" "eks_karpenter_ami_id" {
  provider                = aws.core_services
  name                    = "EKS_KARPENTER_AMI_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "eks_karpenter_ami_id" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.eks_karpenter_ami_id.id
  secret_string = var.eks_karpenter_ami_id
}

resource "aws_secretsmanager_secret" "gha_vpn_cert" {
  provider                = aws.core_services
  name                    = "GHA_VPN_CERT"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "gha_vpn_cert" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.gha_vpn_cert.id
  secret_string = module.gha_vpn.client_vpn_certificate_pem
}

resource "aws_secretsmanager_secret" "gha_vpn_key" {
  provider                = aws.core_services
  name                    = "GHA_VPN_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "gha_vpn_key" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.gha_vpn_key.id
  secret_string = module.gha_vpn.client_vpn_private_key_pem
}
