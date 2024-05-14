resource "aws_secretsmanager_secret" "nginx_target_group_arn" {
  name = "NGINX_TARGET_GROUP_ARN"
}

resource "aws_secretsmanager_secret_version" "nginx_target_group_arn" {
  secret_id     = aws_secretsmanager_secret.nginx_target_group_arn.id
  secret_string = aws_alb_target_group.internal_nginx_http.arn
}

resource "aws_secretsmanager_secret" "pr_bot_app_id" {
  name = "PR_BOT_APP_ID"
}

resource "aws_secretsmanager_secret_version" "pr_bot_app_id" {
  secret_id     = aws_secretsmanager_secret.pr_bot_app_id.id
  secret_string = var.pr_bot_app_id
}

resource "aws_secretsmanager_secret" "pr_bot_private_key" {
  name = "PR_BOT_PRIVATE_KEY"
}

resource "aws_secretsmanager_secret_version" "pr_bot_private_key" {
  secret_id     = aws_secretsmanager_secret.pr_bot_private_key.id
  secret_string = var.pr_bot_private_key
}

resource "aws_secretsmanager_secret" "pr_bot_installation_id" {
  name = "PR_BOT_INSTALLATION_ID"
}

resource "aws_secretsmanager_secret_version" "pr_bot_installation_id" {
  secret_id     = aws_secretsmanager_secret.pr_bot_installation_id.id
  secret_string = var.pr_bot_installation_id
}

resource "aws_secretsmanager_secret" "base_domain" {
  name = "BASE_DOMAIN"
}

resource "aws_secretsmanager_secret_version" "base_domain" {
  secret_id     = aws_secretsmanager_secret.base_domain.id
  secret_string = var.base_domain
}

resource "aws_secretsmanager_secret" "aws_region" {
  name = "AWS_REGION"
}

resource "aws_secretsmanager_secret_version" "aws_region" {
  secret_id     = aws_secretsmanager_secret.aws_region.id
  secret_string = var.region
}

resource "aws_secretsmanager_secret" "admin_target_group_arn" {
  name = "ADMIN_TARGET_GROUP_ARN"
}

resource "aws_secretsmanager_secret_version" "admin_target_group_arn" {
  secret_id     = aws_secretsmanager_secret.admin_target_group_arn.id
  secret_string = aws_alb_target_group.notification-canada-ca-admin.arn
}

resource "aws_secretsmanager_secret" "api_target_group_arn" {
  name = "API_TARGET_GROUP_ARN"
}

resource "aws_secretsmanager_secret_version" "api_target_group_arn" {
  secret_id     = aws_secretsmanager_secret.api_target_group_arn.id
  secret_string = aws_alb_target_group.notification-canada-ca-api.arn
}

resource "aws_secretsmanager_secret" "documentation_target_group_arn" {
  name = "DOCUMENTATION_TARGET_GROUP_ARN"
}

resource "aws_secretsmanager_secret_version" "documentation_target_group_arn" {
  secret_id     = aws_secretsmanager_secret.documentation_target_group_arn.id
  secret_string = aws_alb_target_group.notification-canada-ca-documentation.arn
}

resource "aws_secretsmanager_secret" "document_download_api_target_group_arn" {
  name = "DOCUMENT_DOWNLOAD_API_TARGET_GROUP_ARN"
}

resource "aws_secretsmanager_secret_version" "document_download_api_target_group_arn" {
  secret_id     = aws_secretsmanager_secret.document_download_api_target_group_arn.id
  secret_string = aws_alb_target_group.notification-canada-ca-document-api.arn
}
