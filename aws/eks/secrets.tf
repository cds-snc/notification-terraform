#THIS IS A LIST OF SECRETS THAT WE ARE PULLING FROM TFVARS AT BUILD TIME
locals {
  secrets = [
    "sre_client_secret",
    "pr_bot_app_id",
    "pr_bot_private_key",
    "pr_bot_installation_id",
    "admin_client_secret",
    "allow_html_service_ids",
    "bulk_send_test_service_id",
    "dangerous_salt",
    "hc_en_service_id",
    "hc_fr_service_id",
    "mixpanel_project_token",
    "sensitive_services",
    "secret_key",
    "sentry_url",
    "new_relic_license_key",
    "gc_articles_api_auth_username",
    "gc_articles_api_auth_password",
    "waf_secret",
    "crm_github_personal_access_token",
    "ff_abtest_service_id",
    "postgres_host",
    "base_domain",
    "debug_key",
    "salesforce_engagement_product_id",
    "salesforce_engagement_record_type",
    "salesforce_engagement_standard_pricebook_id",
    "salesforce_engagement_generic_account_id",
    "salesforce_password",
    "salesforce_security_token",
    "salesforce_username",
    "sendgrid_api_key",
    "sql_alchemy_database_uri",
    "twilio_account_sid",
    "zendesk_sell_api_url",
    "zendesk_sell_api_key",
    "zendesk_api_url",
    "zendesk_api_key",
    "aws_pinpoint_region",
    "aws_region",
    "fresh_des_api_url",
    "fresh_desk_api_key",
    "fresh_desk_product_id",
    "sqlalchemy_database_reader_uri",
  ]
}


# THESE ARE USED TO CREATE EACH SECRET IN THE ABOVE LIST

resource "aws_secretsmanager_secret" "secrets" {
  for_each                = toset(local.secrets)
  name                    = upper(each.key)
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "secrets" {
  for_each      = toset(local.secrets)
  secret_id     = aws_secretsmanager_secret.secrets[each.key].id
  secret_string = "var.${each.key}"
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