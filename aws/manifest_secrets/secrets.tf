resource "aws_secretsmanager_secret" "admin_client_secret" {
  provider                = aws.core_services
  name                    = "ADMIN_CLIENT_SECRET"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "admin_client_secret_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.admin_client_secret.id
  secret_string = var.admin_client_secret
}

resource "aws_secretsmanager_secret" "auth_tokens" {
  provider                = aws.core_services
  name                    = "AUTH_TOKENS"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "auth_tokens_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.auth_tokens.id
  secret_string = var.auth_tokens
}

resource "aws_secretsmanager_secret" "airtable_api_key" {
  provider                = aws.core_services
  name                    = "AIRTABLE_API_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "airtable_api_key_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.airtable_api_key.id
  secret_string = var.airtable_api_key
}

resource "aws_secretsmanager_secret" "document_download_api_key" {
  provider                = aws.core_services
  name                    = "DOCUMENT_DOWNLOAD_API_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "document_download_api_key_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.document_download_api_key.id
  secret_string = var.auth_tokens
}

resource "aws_secretsmanager_secret" "aws_route53_zone" {
  provider                = aws.core_services
  name                    = "AWS_ROUTE53_ZONE"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "aws_route53_zone_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.aws_route53_zone.id
  secret_string = var.aws_route53_zone
}

resource "aws_secretsmanager_secret" "aws_ses_access_key" {
  provider                = aws.core_services
  name                    = "AWS_SES_ACCESS_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "aws_ses_access_key_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.aws_ses_access_key.id
  secret_string = var.aws_ses_access_key
}

resource "aws_secretsmanager_secret" "aws_ses_secret_key" {
  provider                = aws.core_services
  name                    = "AWS_SES_SECRET_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "aws_ses_secret_key_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.aws_ses_secret_key.id
  secret_string = var.aws_ses_secret_key
}

resource "aws_secretsmanager_secret" "dangerous_salt" {
  provider                = aws.core_services
  name                    = "DANGEROUS_SALT"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "dangerous_salt_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.dangerous_salt.id
  secret_string = var.dangerous_salt
}

resource "aws_secretsmanager_secret" "debug_key" {
  provider                = aws.core_services
  name                    = "DEBUG_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "debug_key_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.debug_key.id
  secret_string = var.debug_key
}

resource "aws_secretsmanager_secret" "fresh_desk_product_id" {
  provider                = aws.core_services
  name                    = "FRESH_DESK_PRODUCT_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "fresh_desk_product_id_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.fresh_desk_product_id.id
  secret_string = var.fresh_desk_product_id
}

resource "aws_secretsmanager_secret" "fresh_desk_api_key" {
  provider                = aws.core_services
  name                    = "FRESH_DESK_API_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "fresh_desk_api_key_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.fresh_desk_api_key.id
  secret_string = var.fresh_desk_api_key
}

resource "aws_secretsmanager_secret" "gc_articles_api_auth_username" {
  provider                = aws.core_services
  name                    = "GC_ARTICLES_API_AUTH_USERNAME"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "gc_articles_api_auth_username_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.gc_articles_api_auth_username.id
  secret_string = var.gc_articles_api_auth_username
}

resource "aws_secretsmanager_secret" "gc_articles_api_auth_password" {
  provider                = aws.core_services
  name                    = "GC_ARTICLES_API_AUTH_PASSWORD"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "gc_articles_api_auth_password_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.gc_articles_api_auth_password.id
  secret_string = var.gc_articles_api_auth_password
}

resource "aws_secretsmanager_secret" "gc_articles_waf_rate_bypass_secret" {
  provider                = aws.core_services
  name                    = "GC_ARTICLES_WAF_RATE_BYPASS_SECRET"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "gc_articles_waf_rate_bypass_secret_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.gc_articles_waf_rate_bypass_secret.id
  secret_string = var.gc_articles_waf_rate_bypass_secret
}

resource "aws_secretsmanager_secret" "mixpanel_project_token" {
  provider                = aws.core_services
  name                    = "MIXPANEL_PROJECT_TOKEN"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "mixpanel_project_token_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.mixpanel_project_token.id
  secret_string = var.mixpanel_project_token
}

resource "aws_secretsmanager_secret" "crm_github_personal_access_token" {
  provider                = aws.core_services
  name                    = "CRM_GITHUB_PERSONAL_ACCESS_TOKEN"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "crm_github_personal_access_token_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.crm_github_personal_access_token.id
  secret_string = var.crm_github_personal_access_token
}

resource "aws_secretsmanager_secret" "secret_key" {
  provider                = aws.core_services
  name                    = "SECRET_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "secret_key_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.secret_key.id
  secret_string = var.secret_key
}

resource "aws_secretsmanager_secret" "sendgrid_api_key" {
  provider                = aws.core_services
  name                    = "SENDGRID_API_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "sendgrid_api_key_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.sendgrid_api_key.id
  secret_string = var.sendgrid_api_key
}

resource "aws_secretsmanager_secret" "waf_secret" {
  provider                = aws.core_services
  name                    = "WAF_SECRET"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "waf_secret_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.waf_secret.id
  secret_string = var.waf_secret
}

resource "aws_secretsmanager_secret" "zendesk_api_key" {
  provider                = aws.core_services
  name                    = "ZENDESK_API_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "zendesk_api_key_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.zendesk_api_key.id
  secret_string = var.zendesk_api_key
}

resource "aws_secretsmanager_secret" "zendesk_sell_api_key" {
  provider                = aws.core_services
  name                    = "ZENDESK_SELL_API_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "zendesk_sell_api_key_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.zendesk_sell_api_key.id
  secret_string = var.zendesk_sell_api_key
}

resource "aws_secretsmanager_secret" "sre_client_secret" {
  provider                = aws.core_services
  name                    = "SRE_CLIENT_SECRET"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "sre_client_secret_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.sre_client_secret.id
  secret_string = var.sre_client_secret
}

resource "aws_secretsmanager_secret" "cache_clear_client_secret" {
  provider                = aws.core_services
  name                    = "CACHE_CLEAR_CLIENT_SECRET"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "cache_clear_client_secret_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.cache_clear_client_secret.id
  secret_string = var.cache_clear_client_secret
}

resource "aws_secretsmanager_secret" "aws_pinpoint_sc_pool_id" {
  provider                = aws.core_services
  name                    = "AWS_PINPOINT_SC_POOL_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "aws_pinpoint_sc_pool_id_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.aws_pinpoint_sc_pool_id.id
  secret_string = var.aws_pinpoint_sc_pool_id
}

resource "aws_secretsmanager_secret" "aws_pinpoint_sc_template_ids" {
  provider                = aws.core_services
  name                    = "AWS_PINPOINT_SC_TEMPLATE_IDS"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "aws_pinpoint_sc_template_ids_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.aws_pinpoint_sc_template_ids.id
  secret_string = var.aws_pinpoint_sc_template_ids
}

resource "aws_secretsmanager_secret" "aws_pinpoint_default_pool_id" {
  provider                = aws.core_services
  name                    = "AWS_PINPOINT_DEFAULT_POOL_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "aws_pinpoint_default_pool_id_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.aws_pinpoint_default_pool_id.id
  secret_string = var.aws_pinpoint_default_pool_id
}

resource "aws_secretsmanager_secret" "sqlalchemy_database_uri" {
  provider                = aws.core_services
  name                    = "SQLALCHEMY_DATABASE_URI"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "sqlalchemy_database_uri_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.sqlalchemy_database_uri.id
  secret_string = "postgresql://${var.app_db_user}:${var.app_db_user_password}@${var.database_read_write_proxy_endpoint}/${var.app_db_database_name}"
}

resource "aws_secretsmanager_secret" "sqlalchemy_database_reader_uri" {
  provider                = aws.core_services
  name                    = "SQLALCHEMY_DATABASE_READER_URI"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "sqlalchemy_database_reader_uri_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.sqlalchemy_database_reader_uri.id
  secret_string = "postgresql://${var.app_db_user}:${var.app_db_user_password}@${var.database_read_only_proxy_endpoint}/${var.app_db_database_name}"
}

resource "aws_secretsmanager_secret" "postgres_host" {
  provider                = aws.core_services
  name                    = "POSTGRES_HOST"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "postgres_host_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.postgres_host.id
  secret_string = var.postgres_cluster_endpoint
}

resource "aws_secretsmanager_secret" "postgres_sql" {
  provider                = aws.core_services
  name                    = "POSTGRES_SQL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "postgres_sql_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.postgres_sql.id
  secret_string = "postgresql://${var.app_db_user}:${var.app_db_user_password}@${var.database_read_write_proxy_endpoint}/${var.app_db_database_name}"
}

resource "aws_secretsmanager_secret" "cache_ops_url" {
  provider                = aws.core_services
  name                    = "CACHE_OPS_URL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "cache_ops_url_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.cache_ops_url.id
  secret_string = "redis://${var.elasticache_queue_cache_primary_endpoint_address}"
}

resource "aws_secretsmanager_secret" "redis_publish_url" {
  provider                = aws.core_services
  name                    = "REDIS_PUBLISH_URL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "redis_publish_url_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.redis_publish_url.id
  secret_string = var.env != "production" ? "redis://${var.elasticache_queue_cache_primary_endpoint_address}" : "redis://${var.redis_primary_endpoint_address}"
}

resource "aws_secretsmanager_secret" "redis_url" {
  provider                = aws.core_services
  name                    = "REDIS_URL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "redis_url_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.redis_url.id
  secret_string = "redis://${var.redis_primary_endpoint_address}"
}

resource "aws_secretsmanager_secret" "cypress_user_pw_secret" {
  provider                = aws.core_services
  name                    = "CYPRESS_USER_PW_SECRET"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "cypress_user_pw_secret_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.cypress_user_pw_secret.id
  secret_string = var.cypress_user_pw_secret
}

resource "aws_secretsmanager_secret" "cypress_auth_client_secret" {
  provider                = aws.core_services
  name                    = "CYPRESS_AUTH_CLIENT_SECRET"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "cypress_auth_client_secret_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.cypress_auth_client_secret.id
  secret_string = var.cypress_auth_client_secret
}

resource "aws_secretsmanager_secret" "docker_hub_username" {
  provider                = aws.core_services
  name                    = "DOCKER_HUB_USERNAME"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "docker_hub_username_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.docker_hub_username.id
  secret_string = var.docker_hub_username
}

resource "aws_secretsmanager_secret" "docker_hub_pat" {
  provider                = aws.core_services
  name                    = "DOCKER_HUB_PAT"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "docker_hub_pat_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.docker_hub_pat.id
  secret_string = var.docker_hub_pat
}

resource "aws_secretsmanager_secret" "signoz_smtp_username" {
  provider                = aws.core_services
  count                   = var.enable_signoz ? 1 : 0
  name                    = "SIGNOZ_SMTP_USERNAME"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "signoz_smtp_username_version" {
  provider      = aws.core_services
  count         = var.enable_signoz ? 1 : 0
  secret_id     = aws_secretsmanager_secret.signoz_smtp_username[0].id
  secret_string = var.signoz_smtp_username
}

resource "aws_secretsmanager_secret" "signoz_smtp_password" {
  provider                = aws.core_services
  count                   = var.enable_signoz ? 1 : 0
  name                    = "SIGNOZ_SMTP_PASSWORD"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "signoz_smtp_password_version" {
  provider      = aws.core_services
  count         = var.enable_signoz ? 1 : 0
  secret_id     = aws_secretsmanager_secret.signoz_smtp_password[0].id
  secret_string = var.signoz_smtp_password
}

resource "aws_secretsmanager_secret" "signoz_dashboard_api_key" {
  provider                = aws.core_services
  count                   = var.enable_signoz ? 1 : 0
  name                    = "SIGNOZ_DASHBOARD_API_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "signoz_dashboard_api_key_version" {
  provider      = aws.core_services
  count         = var.enable_signoz ? 1 : 0
  secret_id     = aws_secretsmanager_secret.signoz_dashboard_api_key[0].id
  secret_string = var.signoz_dashboard_api_key
}

resource "aws_secretsmanager_secret" "signoz_postgres_password" {
  provider                = aws.core_services
  count                   = var.enable_signoz ? 1 : 0
  name                    = "SIGNOZ_POSTGRES_PASSWORD"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "signoz_postgres_password_version" {
  provider      = aws.core_services
  count         = var.enable_signoz ? 1 : 0
  secret_id     = aws_secretsmanager_secret.signoz_postgres_password[0].id
  secret_string = var.signoz_postgres_password
}

resource "aws_secretsmanager_secret" "falco_credentials" {
  provider                = aws.core_services
  name                    = "FALCO_CREDENTIALS"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "falco_credentials_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.falco_credentials.id
  secret_string = var.falco_credentials
}

resource "aws_secretsmanager_secret" "falco_slack_webhook_url" {
  provider                = aws.core_services
  name                    = "FALCO_SLACK_WEBHOOK_URL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "falco_slack_webhook_url_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.falco_slack_webhook_url.id
  secret_string = var.falco_slack_webhook_url
}

resource "aws_secretsmanager_secret" "scan_verdict_callback_token" {
  provider                = aws.core_services
  name                    = "SCAN_VERDICT_CALLBACK_TOKEN"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "scan_verdict_callback_token_version" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.scan_verdict_callback_token.id
  secret_string = var.scan_verdict_callback_token
}
