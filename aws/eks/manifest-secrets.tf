resource "aws_secretsmanager_secret" "admin_client_secret" {
  name                    = "ADMIN_CLIENT_SECRET"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "admin_client_secret" {
  secret_id     = aws_secretsmanager_secret.admin_client_secret.id
  secret_string = var.admin_client_secret
}

resource "aws_secretsmanager_secret" "crm_github_personal_access_token" {
  name                    = "CRM_GITHUB_PERSONAL_ACCESS_TOKEN"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "crm_github_personal_access_token" {
  secret_id     = aws_secretsmanager_secret.crm_github_personal_access_token.id
  secret_string = var.crm_github_personal_access_token
}

resource "aws_secretsmanager_secret" "dangerous_salt" {
  name                    = "DANGEROUS_SALT"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "dangerous_salt" {
  secret_id     = aws_secretsmanager_secret.dangerous_salt.id
  secret_string = var.dangerous_salt
}

resource "aws_secretsmanager_secret" "salesforce_engagement_product_id" {
  name                    = "SALESFORCE_ENGAGEMENT_PRODUCT_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "salesforce_engagement_product_id" {
  secret_id     = aws_secretsmanager_secret.salesforce_engagement_product_id.id
  secret_string = var.salesforce_engagement_product_id
}

resource "aws_secretsmanager_secret" "salesforce_engagement_record_type" {
  name                    = "SALESFORCE_ENGAGEMENT_RECORD_TYPE"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "salesforce_engagement_record_type" {
  secret_id     = aws_secretsmanager_secret.salesforce_engagement_record_type.id
  secret_string = var.salesforce_engagement_record_type
}

resource "aws_secretsmanager_secret" "salesforce_engagement_standard_pricebook_id" {
  name                    = "SALESFORCE_ENGAGEMENT_STANDARD_PRICEBOOK_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "salesforce_engagement_standard_pricebook_id" {
  secret_id     = aws_secretsmanager_secret.salesforce_engagement_standard_pricebook_id.id
  secret_string = var.salesforce_engagement_standard_pricebook_id
}

resource "aws_secretsmanager_secret" "salesforce_generic_account_id" {
  name                    = "SALESFORCE_GENERIC_ACCOUNT_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "salesforce_generic_account_id" {
  secret_id     = aws_secretsmanager_secret.salesforce_generic_account_id.id
  secret_string = var.salesforce_generic_account_id
}

resource "aws_secretsmanager_secret" "salesforce_password" {
  name                    = "SALESFORCE_PASSWORD"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "salesforce_password" {
  secret_id     = aws_secretsmanager_secret.salesforce_password.id
  secret_string = var.salesforce_password
}

resource "aws_secretsmanager_secret" "salesforce_security_token" {
  name                    = "SALESFORCE_SECURITY_TOKEN"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "salesforce_security_token" {
  secret_id     = aws_secretsmanager_secret.salesforce_security_token.id
  secret_string = var.salesforce_security_token
}

resource "aws_secretsmanager_secret" "salesforce_username" {
  name                    = "SALESFORCE_USERNAME"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "salesforce_username" {
  secret_id     = aws_secretsmanager_secret.salesforce_username.id
  secret_string = var.salesforce_username
}

resource "aws_secretsmanager_secret" "sendgrid_api_key" {
  name                    = "SENDGRID_API_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "secret_key" {
  name                    = "SECRET_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "secret_key" {
  secret_id     = aws_secretsmanager_secret.secret_key.id
  secret_string = var.secret_key
}



resource "aws_secretsmanager_secret_version" "sendgrid_api_key" {
  secret_id     = aws_secretsmanager_secret.sendgrid_api_key.id
  secret_string = var.sendgrid_api_key
}

resource "aws_secretsmanager_secret" "aws_us_toll_free_number" {
  name                    = "AWS_US_TOLL_FREE_NUMBER"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "aws_us_toll_free_number" {
  secret_id     = aws_secretsmanager_secret.aws_us_toll_free_number.id
  secret_string = var.aws_us_toll_free_number
}

resource "aws_secretsmanager_secret" "zendesk_api_key" {
  name                    = "ZENDESK_API_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "zendesk_api_key" {
  secret_id     = aws_secretsmanager_secret.zendesk_api_key.id
  secret_string = var.zendesk_api_key
}

resource "aws_secretsmanager_secret" "zendesk_api_url" {
  name                    = "ZENDESK_API_URL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "zendesk_api_url" {
  secret_id     = aws_secretsmanager_secret.zendesk_api_url.id
  secret_string = var.zendesk_api_url
}

resource "aws_secretsmanager_secret" "zendesk_sell_api_key" {
  name                    = "ZENDESK_SELL_API_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "zendesk_sell_api_key" {
  secret_id     = aws_secretsmanager_secret.zendesk_sell_api_key.id
  secret_string = var.zendesk_sell_api_key
}

resource "aws_secretsmanager_secret" "zendesk_sell_api_url" {
  name                    = "ZENDESK_SELL_API_URL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "zendesk_sell_api_url" {
  secret_id     = aws_secretsmanager_secret.zendesk_sell_api_url.id
  secret_string = var.zendesk_sell_api_url
}

resource "aws_secretsmanager_secret" "allow_html_service_ids" {
  name                    = "ALLOW_HTML_SERVICE_IDS"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "allow_html_service_ids" {
  secret_id     = aws_secretsmanager_secret.allow_html_service_ids.id
  secret_string = var.allow_html_service_ids
}

resource "aws_secretsmanager_secret" "fresh_desk_api_url" {
  name                    = "FRESH_DESK_API_URL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "fresh_desk_api_url" {
  secret_id     = aws_secretsmanager_secret.fresh_desk_api_url.id
  secret_string = var.fresh_desk_api_url
}

resource "aws_secretsmanager_secret" "fresh_desk_api_key" {
  name                    = "FRESH_DESK_API_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "fresh_desk_api_key" {
  secret_id     = aws_secretsmanager_secret.fresh_desk_api_key.id
  secret_string = var.fresh_desk_api_key
}

resource "aws_secretsmanager_secret" "fresh_desk_product_id" {
  name                    = "FRESH_DESK_PRODUCT_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "fresh_desk_product_id" {
  secret_id     = aws_secretsmanager_secret.fresh_desk_product_id.id
  secret_string = var.fresh_desk_product_id
}

resource "aws_secretsmanager_secret" "debug_key" {
  name                    = "DEBUG_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "debug_key" {
  secret_id     = aws_secretsmanager_secret.debug_key.id
  secret_string = var.debug_key
}

resource "aws_secretsmanager_secret" "sre_client_secret" {
  name                    = "SRE_CLIENT_SECRET"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "sre_client_secret" {
  secret_id     = aws_secretsmanager_secret.sre_client_secret.id
  secret_string = var.sre_client_secret
}

resource "aws_secretsmanager_secret" "sentry_url" {
  name                    = "SENTRY_URL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "sentry_url" {
  secret_id     = aws_secretsmanager_secret.sentry_url.id
  secret_string = var.sentry_url
}

resource "aws_secretsmanager_secret" "new_relic_license_key" {
  name                    = "NEW_RELIC_LICENSE_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "new_relic_license_key" {
  secret_id     = aws_secretsmanager_secret.new_relic_license_key.id
  secret_string = var.new_relic_license_key
}
