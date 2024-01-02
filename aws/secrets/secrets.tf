resource "aws_secretsmanager_secret" "admin_client_secret" {
  name = "ADMIN_CLIENT_SECRET"
}

resource "aws_secretsmanager_secret_version" "admin_client_secret" {
  secret_id     = aws_secretsmanager_secret.admin_client_secret.id
  secret_string = var.admin_client_secret
}

resource "aws_secretsmanager_secret" "aws_ses_access_key" {
  name = "AWS_SES_ACCESS_KEY"
}

resource "aws_secretsmanager_secret_version" "aws_ses_access_key" {
  secret_id     = aws_secretsmanager_secret.aws_ses_access_key.id
  secret_string = var.aws_ses_access_key
}

resource "aws_secretsmanager_secret" "aws_ses_secret_key" {
  name = "AWS_SES_SECRET_KEY"
}

resource "aws_secretsmanager_secret_version" "aws_ses_secret_key" {
  secret_id     = aws_secretsmanager_secret.aws_ses_secret_key.id
  secret_string = var.aws_ses_secret_key
}


resource "aws_secretsmanager_secret" "crm_github_personal_access_token" {
  name = "CRM_GITHUB_PERSONAL_ACCESS_TOKEN"
}

resource "aws_secretsmanager_secret_version" "crm_github_personal_access_token" {
  secret_id     = aws_secretsmanager_secret.crm_github_personal_access_token.id
  secret_string = var.crm_github_personal_access_token
}

resource "aws_secretsmanager_secret" "debug_key" {
  name = "DEBUG_KEY"
}

resource "aws_secretsmanager_secret_version" "debug_key" {
  secret_id     = aws_secretsmanager_secret.debug_key.id
  secret_string = var.debug_key
}

resource "aws_secretsmanager_secret" "dangerous_salt" {
  name = "DANGEROUS_SALT"
}

resource "aws_secretsmanager_secret_version" "dangerous_salt" {
  secret_id     = aws_secretsmanager_secret.dangerous_salt.id
  secret_string = var.dangerous_salt
}

resource "aws_secretsmanager_secret" "postgres_host" {
  name = "POSTGRES_HOST"
}

resource "aws_secretsmanager_secret_version" "postgres_host" {
  secret_id     = aws_secretsmanager_secret.postgres_host.id
  secret_string = var.postgres_host
}

resource "aws_secretsmanager_secret" "redis_url" {
  name = "REDIS_URL"
}

resource "aws_secretsmanager_secret_version" "redis_url" {
  secret_id     = aws_secretsmanager_secret.redis_url.id
  secret_string = var.redis_url
}


resource "aws_secretsmanager_secret" "salesforce_engagement_product_id" {
  name = "SALESFORCE_ENGAGEMENT_PRODUCT_ID"
}

resource "aws_secretsmanager_secret_version" "salesforce_engagement_product_id" {
  secret_id     = aws_secretsmanager_secret.salesforce_engagement_product_id.id
  secret_string = var.salesforce_engagement_product_id
}
resource "aws_secretsmanager_secret" "salesforce_engagement_record_type" {
  name = "SALESFORCE_ENGAGEMENT_RECORD_TYPE"
}

resource "aws_secretsmanager_secret_version" "salesforce_engagement_record_type" {
  secret_id     = aws_secretsmanager_secret.salesforce_engagement_record_type.id
  secret_string = var.salesforce_engagement_record_type
}
resource "aws_secretsmanager_secret" "salesforce_engagement_standard_pricebook_id" {
  name = "SALESFORCE_ENGAGEMENT_STANDARD_PRICEBOOK_ID"
}

resource "aws_secretsmanager_secret_version" "salesforce_engagement_standard_pricebook_id" {
  secret_id     = aws_secretsmanager_secret.salesforce_engagement_standard_pricebook_id.id
  secret_string = var.salesforce_engagement_standard_pricebook_id
}
resource "aws_secretsmanager_secret" "salesforce_generic_account_id" {
  name = "SALESFORCE_GENERIC_ACCOUNT_ID"
}

resource "aws_secretsmanager_secret_version" "salesforce_generic_account_id" {
  secret_id     = aws_secretsmanager_secret.salesforce_generic_account_id.id
  secret_string = var.salesforce_generic_account_id
}
resource "aws_secretsmanager_secret" "salesforce_username" {
  name = "SALESFORCE_USERNAME"
}

resource "aws_secretsmanager_secret_version" "salesforce_username" {
  secret_id     = aws_secretsmanager_secret.salesforce_username.id
  secret_string = var.salesforce_username
}
resource "aws_secretsmanager_secret" "salesforce_password" {
  name = "SALESFORCE_PASSWORD"
}

resource "aws_secretsmanager_secret_version" "salesforce_password" {
  secret_id     = aws_secretsmanager_secret.salesforce_password.id
  secret_string = var.salesforce_password
}
resource "aws_secretsmanager_secret" "salesforce_security_token" {
  name = "SALESFORCE_SECURITY_TOKEN"
}

resource "aws_secretsmanager_secret_version" "salesforce_security_token" {
  secret_id     = aws_secretsmanager_secret.salesforce_security_token.id
  secret_string = var.salesforce_security_token
}
resource "aws_secretsmanager_secret" "salesforce_client_privatekey" {
  name = "SALESFORCE_CLIENT_PRIVATEKEY"
}

resource "aws_secretsmanager_secret_version" "salesforce_client_privatekey" {
  secret_id     = aws_secretsmanager_secret.salesforce_client_privatekey.id
  secret_string = var.salesforce_client_privatekey
}

resource "aws_secretsmanager_secret" "secret_key" {
  name = "SECRET_KEY"
}

resource "aws_secretsmanager_secret_version" "secret_key" {
  secret_id     = aws_secretsmanager_secret.secret_key.id
  secret_string = var.secret_key
}

resource "aws_secretsmanager_secret" "sendgrid_api_key" {
  name = "SENDGRID_API_KEY"
}

resource "aws_secretsmanager_secret_version" "sendgrid_api_key" {
  secret_id     = aws_secretsmanager_secret.sendgrid_api_key.id
  secret_string = var.sendgrid_api_key
}

resource "aws_secretsmanager_secret" "sql_alchemy_database_reader_uri" {
  name = "SQLALCHEMY_DATABASE_READER_URI"
}

resource "aws_secretsmanager_secret_version" "sql_alchemy_database_reader_uri" {
  secret_id     = aws_secretsmanager_secret.sql_alchemy_database_reader_uri.id
  secret_string = "postgresql://postgres:${var.app_db_user_password}@${var.database_read_only_proxy_endpoint}/${var.database_name}"
}

resource "aws_secretsmanager_secret" "sql_alchemy_database_writer_uri" {
  name = "SQLALCHEMY_DATABASE_WRITER_URI"
}

resource "aws_secretsmanager_secret_version" "sql_alchemy_database_writer_uri" {
  secret_id     = aws_secretsmanager_secret.sql_alchemy_database_writer_uri.id
  secret_string = "postgresql://postgres:${var.app_db_user_password}@${var.database_read_write_proxy_endpoint}/${var.database_name}"
}
resource "aws_secretsmanager_secret" "twilio_account_sid" {
  name = "TWILIO_ACCOUNT_SID"
}

resource "aws_secretsmanager_secret_version" "twilio_account_sid" {
  secret_id     = aws_secretsmanager_secret.twilio_account_sid.id
  secret_string = var.twilio_account_sid
}
resource "aws_secretsmanager_secret" "twilio_auth_token" {
  name = "TWILIO_AUTH_TOKEN"
}

resource "aws_secretsmanager_secret_version" "twilio_auth_token" {
  secret_id     = aws_secretsmanager_secret.twilio_auth_token.id
  secret_string = var.twilio_auth_token
}
resource "aws_secretsmanager_secret" "twilio_from_number" {
  name = "TWILIO_FROM_NUMBER"
}

resource "aws_secretsmanager_secret_version" "twilio_from_number" {
  secret_id     = aws_secretsmanager_secret.twilio_from_number.id
  secret_string = var.twilio_from_number
}

resource "aws_secretsmanager_secret" "zendesk_api_key" {
  name = "ZENDESK_API_KEY"
}

resource "aws_secretsmanager_secret_version" "zendesk_api_key" {
  secret_id     = aws_secretsmanager_secret.zendesk_api_key.id
  secret_string = var.zendesk_api_key
}
resource "aws_secretsmanager_secret" "zendesk_sell_api_key" {
  name = "ZENDESK_SELL_API_KEY"
}

resource "aws_secretsmanager_secret_version" "zendesk_sell_api_key" {
  secret_id     = aws_secretsmanager_secret.zendesk_sell_api_key.id
  secret_string = var.zendesk_sell_api_key
}

resource "aws_secretsmanager_secret" "fresh_desk_product_id" {
  name = "FRESH_DESK_PRODUCT_ID"
}

resource "aws_secretsmanager_secret_version" "fresh_desk_product_id" {
  secret_id     = aws_secretsmanager_secret.fresh_desk_product_id.id
  secret_string = var.fresh_desk_product_id
}

resource "aws_secretsmanager_secret" "fresh_desk_api_key" {
  name = "FRESH_DESK_API_KEY"
}

resource "aws_secretsmanager_secret_version" "fresh_desk_api_key" {
  secret_id     = aws_secretsmanager_secret.fresh_desk_api_key.id
  secret_string = var.fresh_desk_api_key
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

resource "aws_secretsmanager_secret" "sre_client_secret" {
  name = "SRE_CLIENT_SECRET"
}

resource "aws_secretsmanager_secret_version" "sre_client_secret" {
  secret_id     = aws_secretsmanager_secret.sre_client_secret.id
  secret_string = var.sre_client_secret
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

resource "aws_secretsmanager_secret" "hasura_access_key" {
  name = "HASURA_ACCESS_KEY"
}

resource "aws_secretsmanager_secret_version" "hasura_access_key" {
  secret_id     = aws_secretsmanager_secret.hasura_access_key.id
  secret_string = var.hasura_access_key
}

resource "aws_secretsmanager_secret" "auth_tokens" {
  name = "AUTH_TOKENS"
}

resource "aws_secretsmanager_secret_version" "auth_tokens" {
  secret_id     = aws_secretsmanager_secret.auth_tokens.id
  secret_string = var.auth_tokens
}


####
resource "aws_secretsmanager_secret" "api_target_group_arn" {
  name = "API_TARGET_GROUP_ARN"
}

resource "aws_secretsmanager_secret_version" "api_target_group_arn" {
  secret_id     = aws_secretsmanager_secret.api_target_group_arn.id
  secret_string = var.api_target_group_arn
}
resource "aws_secretsmanager_secret" "admin_target_group_arn" {
  name = "ADMIN_TARGET_GROUP_ARN"
}

resource "aws_secretsmanager_secret_version" "admin_target_group_arn" {
  secret_id     = aws_secretsmanager_secret.admin_target_group_arn.id
  secret_string = var.admin_target_group_arn
}
resource "aws_secretsmanager_secret" "document_api_target_group_arn" {
  name = "DOCUMENT_API_TARGET_GROUP_ARN"
}

resource "aws_secretsmanager_secret_version" "document_api_target_group_arn" {
  secret_id     = aws_secretsmanager_secret.document_api_target_group_arn.id
  secret_string = var.document_api_target_group_arn
}
resource "aws_secretsmanager_secret" "documentation_target_group_arn" {
  name = "DOCUMENTATION_TARGET_GROUP_ARN"
}

resource "aws_secretsmanager_secret_version" "documentation_target_group_arn" {
  secret_id     = aws_secretsmanager_secret.documentation_target_group_arn.id
  secret_string = var.documentation_target_group_arn
}

resource "aws_secretsmanager_secret" "document_target_group_arn" {
  name = "DOCUMENT_TARGET_GROUP_ARN"
}

resource "aws_secretsmanager_secret_version" "document_target_group_arn" {
  secret_id     = aws_secretsmanager_secret.document_target_group_arn.id
  secret_string = var.document_target_group_arn
}