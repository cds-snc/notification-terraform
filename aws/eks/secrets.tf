resource "aws_secretsmanager_secret" "nginx_target_group_arn" {
  name = "NGINX_TARGET_GROUP_ARN"
}

resource "aws_secretsmanager_secret_version" "nginx_target_group_arn" {
  secret_id     = aws_secretsmanager_secret.nginx_target_group_arn.id
  secret_string = aws_alb_target_group.internal_nginx_http.arn
}

resource "aws_secretsmanager_secret" "admin_target_group_arn" {
  name = "ADMIN_TARGET_GROUP_ARN"
}

resource "aws_secretsmanager_secret_version" "admin_target_group_arn" {
  secret_id     = aws_secretsmanager_secret.admin_target_group_arn.id
  secret_string = aws_alb_target_group.notification-canada-ca-admin.arn
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

resource "aws_secretsmanager_secret" "admin_client_secret" {
  name = "ADMIN_CLIENT_SECRET"
}

resource "aws_secretsmanager_secret_version" "admin_client_secret" {
  secret_id     = aws_secretsmanager_secret.admin_client_secret.id
  secret_string = var.admin_client_secret
}

resource "aws_secretsmanager_secret" "allow_html_service_ids" {
  name = "ALLOW_HTML_SERVICE_IDS"
}

resource "aws_secretsmanager_secret_version" "allow_html_service_ids" {
  secret_id     = aws_secretsmanager_secret.allow_html_service_ids.id
  secret_string = var.allow_html_service_ids
}

resource "aws_secretsmanager_secret" "bulk_send_test_service_id" {
  name = "BULK_SEND_TEST_SERVICE_ID"
}

resource "aws_secretsmanager_secret_version" "bulk_send_test_service_id" {
  secret_id     = aws_secretsmanager_secret.bulk_send_test_service_id.id
  secret_string = var.bulk_send_test_service_id
}

resource "aws_secretsmanager_secret" "dangerous_salt" {
  name = "DANGEROUS_SALT"
}

resource "aws_secretsmanager_secret_version" "dangerous_salt" {
  secret_id     = aws_secretsmanager_secret.dangerous_salt.id
  secret_string = var.dangerous_salt
}

resource "aws_secretsmanager_secret" "hc_en_service_id" {
  name = "HC_EN_SERVICE_ID"
}

resource "aws_secretsmanager_secret_version" "hc_en_service_id" {
  secret_id     = aws_secretsmanager_secret.hc_en_service_id.id
  secret_string = var.hc_en_service_id
}

resource "aws_secretsmanager_secret" "hc_fr_service_id" {
  name = "HC_FR_SERVICE_ID"
}

resource "aws_secretsmanager_secret_version" "hc_fr_service_id" {
  secret_id     = aws_secretsmanager_secret.hc_fr_service_id.id
  secret_string = var.hc_fr_service_id
}

resource "aws_secretsmanager_secret" "mixpanel_project_token" {
  name = "MIXPANEL_PROJECT_TOKEN"
}

resource "aws_secretsmanager_secret_version" "mixpanel_project_token" {
  secret_id     = aws_secretsmanager_secret.mixpanel_project_token.id
  secret_string = var.mixpanel_project_token
}

resource "aws_secretsmanager_secret" "sensitive_services" {
  name = "SENSITIVE_SERVICES"
}

resource "aws_secretsmanager_secret_version" "sensitive_services" {
  secret_id     = aws_secretsmanager_secret.sensitive_services.id
  secret_string = var.sensitive_services
}

resource "aws_secretsmanager_secret" "secret_key" {
  name = "SECRET_KEY"
}

resource "aws_secretsmanager_secret_version" "secret_key" {
  secret_id     = aws_secretsmanager_secret.secret_key.id
  secret_string = var.secret_key
}

resource "aws_secretsmanager_secret" "sentry_url" {
  name = "SENTRY_URL"
}

resource "aws_secretsmanager_secret_version" "sentry_url" {
  secret_id     = aws_secretsmanager_secret.sentry_url.id
  secret_string = var.sentry_url
}

resource "aws_secretsmanager_secret" "new_relic_license_key" {
  name = "NEW_RELIC_LICENSE_KEY"
}

resource "aws_secretsmanager_secret_version" "new_relic_license_key" {
  secret_id     = aws_secretsmanager_secret.new_relic_license_key.id
  secret_string = var.new_relic_license_key
}

resource "aws_secretsmanager_secret" "gc_articles_api_auth_username" {
  name = "GC_ARTICLES_API_AUTH_USERNAME"
}

resource "aws_secretsmanager_secret_version" "gc_articles_api_auth_username" {
  secret_id     = aws_secretsmanager_secret.gc_articles_api_auth_username.id
  secret_string = var.gc_articles_api_auth_username
}

resource "aws_secretsmanager_secret" "gc_articles_api_auth_password" {
  name = "GC_ARTICLES_API_AUTH_PASSWORD"
}

resource "aws_secretsmanager_secret_version" "gc_articles_api_auth_password" {
  secret_id     = aws_secretsmanager_secret.gc_articles_api_auth_password.id
  secret_string = var.gc_articles_api_auth_password
}

resource "aws_secretsmanager_secret" "waf_secret" {
  name = "WAF_SECRET"
}

resource "aws_secretsmanager_secret_version" "waf_secret" {
  secret_id     = aws_secretsmanager_secret.waf_secret.id
  secret_string = var.waf_secret
}

resource "aws_secretsmanager_secret" "crm_github_personal_access_token" {
  name = "CRM_GITHUB_PERSONAL_ACCESS_TOKEN"
}

resource "aws_secretsmanager_secret_version" "crm_github_personal_access_token" {
  secret_id     = aws_secretsmanager_secret.crm_github_personal_access_token.id
  secret_string = var.crm_github_personal_access_token
}

resource "aws_secretsmanager_secret" "ff_abtest_service_id" {
  name = "FF_ABTEST_SERVICE_ID"
}

resource "aws_secretsmanager_secret_version" "ff_abtest_service_id" {
  secret_id     = aws_secretsmanager_secret.ff_abtest_service_id.id
  secret_string = var.ff_abtest_service_id
}