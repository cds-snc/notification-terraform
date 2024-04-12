# THESE ARE USED TO CREATE EACH SECRET IN THE ABOVE LIST

resource "aws_secretsmanager_secret" "secrets" {
  for_each                = var.secrets
  name                    = upper(each.key)
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "secrets" {
  for_each      = var.secrets
  secret_id     = aws_secretsmanager_secret.secrets[each.key].id
  secret_string = each.value
}

# THESE BELOW ARE THE SECRETS THAT ARE PULLED FROM DEPLOYED ARCHITECTURE
# THEY CAN'T BE CREATED AT BUILD TIME

resource "aws_secretsmanager_secret" "nginx_target_group_arn" {
  name                    = "NGINX_TARGET_GROUP_ARN"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "nginx_target_group_arn" {
  secret_id     = aws_secretsmanager_secret.nginx_target_group_arn.id
  secret_string = aws_alb_target_group.internal_nginx_http.arn
}

resource "aws_secretsmanager_secret" "admin_target_group_arn" {
  name                    = "ADMIN_TARGET_GROUP_ARN"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "admin_target_group_arn" {
  secret_id     = aws_secretsmanager_secret.admin_target_group_arn.id
  secret_string = aws_alb_target_group.notification-canada-ca-admin.arn
}

resource "aws_secretsmanager_secret" "api_target_group_arn" {
  name                    = "API_TARGET_GROUP_ARN"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "api_target_group_arn" {
  secret_id     = aws_secretsmanager_secret.api_target_group_arn.id
  secret_string = aws_alb_target_group.notification-canada-ca-api.arn
}

resource "aws_secretsmanager_secret" "documentation_target_group_arn" {
  name                    = "DOCUMENTATION_TARGET_GROUP_ARN"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "documentation_target_group_arn" {
  secret_id     = aws_secretsmanager_secret.documentation_target_group_arn.id
  secret_string = aws_alb_target_group.notification-canada-ca-documentation.arn
}

resource "aws_secretsmanager_secret" "document_api_target_group_arn" {
  name                    = "DOCUMENT_DOWNLOAD_API_TARGET_GROUP_ARN"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "document_api_target_group_arn" {
  secret_id     = aws_secretsmanager_secret.document_api_target_group_arn.id
  secret_string = aws_alb_target_group.notification-canada-ca-document-api.arn
}