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

