resource "aws_secretsmanager_secret" "manifest_admin_client_secret" {
  name                    = "MANIFEST_ADMIN_CLIENT_SECRET"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_admin_client_secret_version" {
  secret_id     = aws_secretsmanager_secret.manifest_admin_client_secret.id
  secret_string = var.manifest_admin_client_secret
}

resource "aws_secretsmanager_secret" "manifest_auth_tokens" {
  name                    = "MANIFEST_AUTH_TOKENS"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_auth_tokens_version" {
  secret_id     = aws_secretsmanager_secret.manifest_auth_tokens.id
  secret_string = var.manifest_auth_tokens
}

resource "aws_secretsmanager_secret" "manifest_document_download_api_key" {
  name                    = "MANIFEST_DOCUMENT_DOWNLOAD_API_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_document_download_api_key_version" {
  secret_id     = aws_secretsmanager_secret.manifest_document_download_api_key.id
  secret_string = var.manifest_document_download_api_key
}

resource "aws_secretsmanager_secret" "manifest_aws_route53_zone" {
  name                    = "MANIFEST_AWS_ROUTE53_ZONE"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_aws_route53_zone_version" {
  secret_id     = aws_secretsmanager_secret.manifest_aws_route53_zone.id
  secret_string = var.manifest_aws_route53_zone
}

resource "aws_secretsmanager_secret" "manifest_aws_ses_access_key" {
  name                    = "MANIFEST_AWS_SES_ACCESS_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_aws_ses_access_key_version" {
  secret_id     = aws_secretsmanager_secret.manifest_aws_ses_access_key.id
  secret_string = var.manifest_aws_ses_access_key
}

resource "aws_secretsmanager_secret" "manifest_aws_ses_secret_key" {
  name                    = "MANIFEST_AWS_SES_SECRET_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_aws_ses_secret_key_version" {
  secret_id     = aws_secretsmanager_secret.manifest_aws_ses_secret_key.id
  secret_string = var.manifest_aws_ses_secret_key
}

resource "aws_secretsmanager_secret" "manifest_dangerous_salt" {
  name                    = "MANIFEST_DANGEROUS_SALT"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_dangerous_salt_version" {
  secret_id     = aws_secretsmanager_secret.manifest_dangerous_salt.id
  secret_string = var.manifest_dangerous_salt
}

resource "aws_secretsmanager_secret" "manifest_debug_key" {
  name                    = "MANIFEST_DEBUG_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_debug_key_version" {
  secret_id     = aws_secretsmanager_secret.manifest_debug_key.id
  secret_string = var.manifest_debug_key
}

resource "aws_secretsmanager_secret" "manifest_fresh_desk_product_id" {
  name                    = "MANIFEST_FRESH_DESK_PRODUCT_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_fresh_desk_product_id_version" {
  secret_id     = aws_secretsmanager_secret.manifest_fresh_desk_product_id.id
  secret_string = var.manifest_fresh_desk_product_id
}

resource "aws_secretsmanager_secret" "manifest_fresh_desk_api_key" {
  name                    = "MANIFEST_FRESH_DESK_API_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_fresh_desk_api_key_version" {
  secret_id     = aws_secretsmanager_secret.manifest_fresh_desk_api_key.id
  secret_string = var.manifest_fresh_desk_api_key
}

resource "aws_secretsmanager_secret" "manifest_gc_articles_api_auth_username" {
  name                    = "MANIFEST_GC_ARTICLES_API_AUTH_USERNAME"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_gc_articles_api_auth_username_version" {
  secret_id     = aws_secretsmanager_secret.manifest_gc_articles_api_auth_username.id
  secret_string = var.manifest_gc_articles_api_auth_username
}

resource "aws_secretsmanager_secret" "manifest_gc_articles_api_auth_password" {
  name                    = "MANIFEST_GC_ARTICLES_API_AUTH_PASSWORD"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_gc_articles_api_auth_password_version" {
  secret_id     = aws_secretsmanager_secret.manifest_gc_articles_api_auth_password.id
  secret_string = var.manifest_gc_articles_api_auth_password
}

resource "aws_secretsmanager_secret" "manifest_mixpanel_project_token" {
  name                    = "MANIFEST_MIXPANEL_PROJECT_TOKEN"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_mixpanel_project_token_version" {
  secret_id     = aws_secretsmanager_secret.manifest_mixpanel_project_token.id
  secret_string = var.manifest_mixpanel_project_token
}

resource "aws_secretsmanager_secret" "manifest_new_relic_license_key" {
  name                    = "MANIFEST_NEW_RELIC_LICENSE_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_new_relic_license_key_version" {
  secret_id     = aws_secretsmanager_secret.manifest_new_relic_license_key.id
  secret_string = var.manifest_new_relic_license_key
}

resource "aws_secretsmanager_secret" "manifest_crm_github_personal_access_token" {
  name                    = "MANIFEST_CRM_GITHUB_PERSONAL_ACCESS_TOKEN"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_crm_github_personal_access_token_version" {
  secret_id     = aws_secretsmanager_secret.manifest_crm_github_personal_access_token.id
  secret_string = var.manifest_crm_github_personal_access_token
}

resource "aws_secretsmanager_secret" "manifest_salesforce_username" {
  name                    = "MANIFEST_SALESFORCE_USERNAME"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_salesforce_username_version" {
  secret_id     = aws_secretsmanager_secret.manifest_salesforce_username.id
  secret_string = var.manifest_salesforce_username
}

resource "aws_secretsmanager_secret" "manifest_salesforce_password" {
  name                    = "MANIFEST_SALESFORCE_PASSWORD"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_salesforce_password_version" {
  secret_id     = aws_secretsmanager_secret.manifest_salesforce_password.id
  secret_string = var.manifest_salesforce_password
}

resource "aws_secretsmanager_secret" "manifest_salesforce_security_token" {
  name                    = "MANIFEST_SALESFORCE_SECURITY_TOKEN"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_salesforce_security_token_version" {
  secret_id     = aws_secretsmanager_secret.manifest_salesforce_security_token.id
  secret_string = var.manifest_salesforce_security_token
}

resource "aws_secretsmanager_secret" "manifest_salesforce_client_privatekey" {
  name                    = "MANIFEST_SALESFORCE_CLIENT_PRIVATEKEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_salesforce_client_privatekey_version" {
  secret_id     = aws_secretsmanager_secret.manifest_salesforce_client_privatekey.id
  secret_string = var.manifest_salesforce_client_privatekey
}

resource "aws_secretsmanager_secret" "manifest_salesforce_engagement_product_id" {
  name                    = "MANIFEST_SALESFORCE_ENGAGEMENT_PRODUCT_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_salesforce_engagement_product_id_version" {
  secret_id     = aws_secretsmanager_secret.manifest_salesforce_engagement_product_id.id
  secret_string = var.manifest_salesforce_engagement_product_id
}

resource "aws_secretsmanager_secret" "manifest_salesforce_engagement_record_type" {
  name                    = "MANIFEST_SALESFORCE_ENGAGEMENT_RECORD_TYPE"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_salesforce_engagement_record_type_version" {
  secret_id     = aws_secretsmanager_secret.manifest_salesforce_engagement_record_type.id
  secret_string = var.manifest_salesforce_engagement_record_type
}

resource "aws_secretsmanager_secret" "manifest_salesforce_engagement_standard_pricebook_id" {
  name                    = "MANIFEST_SALESFORCE_ENGAGEMENT_STANDARD_PRICEBOOK_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_salesforce_engagement_standard_pricebook_id_version" {
  secret_id     = aws_secretsmanager_secret.manifest_salesforce_engagement_standard_pricebook_id.id
  secret_string = var.manifest_salesforce_engagement_standard_pricebook_id
}

resource "aws_secretsmanager_secret" "manifest_salesforce_generic_account_id" {
  name                    = "MANIFEST_SALESFORCE_GENERIC_ACCOUNT_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_salesforce_generic_account_id_version" {
  secret_id     = aws_secretsmanager_secret.manifest_salesforce_generic_account_id.id
  secret_string = var.manifest_salesforce_generic_account_id
}

resource "aws_secretsmanager_secret" "manifest_secret_key" {
  name                    = "MANIFEST_SECRET_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_secret_key_version" {
  secret_id     = aws_secretsmanager_secret.manifest_secret_key.id
  secret_string = var.manifest_secret_key
}

resource "aws_secretsmanager_secret" "manifest_sendgrid_api_key" {
  name                    = "MANIFEST_SENDGRID_API_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_sendgrid_api_key_version" {
  secret_id     = aws_secretsmanager_secret.manifest_sendgrid_api_key.id
  secret_string = var.manifest_sendgrid_api_key
}

resource "aws_secretsmanager_secret" "manifest_waf_secret" {
  name                    = "MANIFEST_WAF_SECRET"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_waf_secret_version" {
  secret_id     = aws_secretsmanager_secret.manifest_waf_secret.id
  secret_string = var.manifest_waf_secret
}

resource "aws_secretsmanager_secret" "manifest_zendesk_api_key" {
  name                    = "MANIFEST_ZENDESK_API_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_zendesk_api_key_version" {
  secret_id     = aws_secretsmanager_secret.manifest_zendesk_api_key.id
  secret_string = var.manifest_zendesk_api_key
}

resource "aws_secretsmanager_secret" "manifest_zendesk_sell_api_key" {
  name                    = "MANIFEST_ZENDESK_SELL_API_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_zendesk_sell_api_key_version" {
  secret_id     = aws_secretsmanager_secret.manifest_zendesk_sell_api_key.id
  secret_string = var.manifest_zendesk_sell_api_key
}

resource "aws_secretsmanager_secret" "manifest_sre_client_secret" {
  name                    = "MANIFEST_SRE_CLIENT_SECRET"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_sre_client_secret_version" {
  secret_id     = aws_secretsmanager_secret.manifest_sre_client_secret.id
  secret_string = var.manifest_sre_client_secret
}

resource "aws_secretsmanager_secret" "manifest_cache_clear_client_secret" {
  name                    = "MANIFEST_CACHE_CLEAR_CLIENT_SECRET"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_cache_clear_client_secret_version" {
  secret_id     = aws_secretsmanager_secret.manifest_cache_clear_client_secret.id
  secret_string = var.manifest_cache_clear_client_secret
}

resource "aws_secretsmanager_secret" "manifest_aws_pinpoint_sc_pool_id" {
  name                    = "MANIFEST_AWS_PINPOINT_SC_POOL_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_aws_pinpoint_sc_pool_id_version" {
  secret_id     = aws_secretsmanager_secret.manifest_aws_pinpoint_sc_pool_id.id
  secret_string = var.manifest_aws_pinpoint_sc_pool_id
}

resource "aws_secretsmanager_secret" "manifest_aws_pinpoint_sc_template_ids" {
  name                    = "MANIFEST_AWS_PINPOINT_SC_TEMPLATE_IDS"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_aws_pinpoint_sc_template_ids_version" {
  secret_id     = aws_secretsmanager_secret.manifest_aws_pinpoint_sc_template_ids.id
  secret_string = var.manifest_aws_pinpoint_sc_template_ids
}

resource "aws_secretsmanager_secret" "manifest_aws_pinpoint_default_pool_id" {
  name                    = "MANIFEST_AWS_PINPOINT_DEFAULT_POOL_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_aws_pinpoint_default_pool_id_version" {
  secret_id     = aws_secretsmanager_secret.manifest_aws_pinpoint_default_pool_id.id
  secret_string = var.manifest_aws_pinpoint_default_pool_id
}

resource "aws_secretsmanager_secret" "manifest_sqlalachemy_database_uri" {
  name                    = "MANIFEST_SQLALCHEMY_DATABASE_URI"
  recovery_window_in_days = 0
}

# THESE BELOW ARE ARE DEPENDENT ON DYNAMICALLY GENERATED AWS INFORMATION

resource "aws_secretsmanager_secret_version" "manifest_sqlalachemy_database_uri" {
  secret_id     = aws_secretsmanager_secret.manifest_sqlalachemy_database_uri.id
  secret_string = "postgresql://${var.app_db_user}:${var.app_db_user_password}@${var.database_read_write_proxy_endpoint}/${var.app_db_database_name}"
}

resource "aws_secretsmanager_secret" "manifest_sqlalachemy_database_reader_uri" {
  name                    = "MANIFEST_SQLALCHEMY_DATABASE_READER_URI"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_sqlalachemy_database_reader_uri" {
  secret_id     = aws_secretsmanager_secret.manifest_sqlalachemy_database_reader_uri.id
  secret_string = "postgresql://${var.app_db_user}:${var.app_db_user_password}@${var.database_read_only_proxy_endpoint}/${var.app_db_database_name}"
}

resource "aws_secretsmanager_secret" "manifest_postgres_host" {
  name                    = "MANIFEST_POSTGRES_HOST"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_postgres_host_version" {
  secret_id     = aws_secretsmanager_secret.manifest_postgres_host.id
  secret_string = var.postgres_cluster_endpoint
}

resource "aws_secretsmanager_secret" "manifest_postgres_sql" {
  name                    = "MANIFEST_POSTGRES_SQL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_postgres_sql_version" {
  secret_id     = aws_secretsmanager_secret.manifest_postgres_sql.id
  secret_string = "postgresql://${var.app_db_user}:${var.app_db_user_password}@${var.database_read_write_proxy_endpoint}/${var.app_db_database_name}"
}

resource "aws_secretsmanager_secret" "manifest_redis_publish_url" {
  name                    = "MANIFEST_REDIS_PUBLISH_URL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_redis_publish_url" {
  secret_id     = aws_secretsmanager_secret.manifest_redis_publish_url.id
  secret_string = "redis://${var.redis_primary_endpoint_address}"
}

resource "aws_secretsmanager_secret" "manifest_redis_url" {
  name                    = "MANIFEST_REDIS_URL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "manifest_redis_url" {
  secret_id     = aws_secretsmanager_secret.manifest_redis_url.id
  secret_string = "redis://${var.redis_primary_endpoint_address}"
}
