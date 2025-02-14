variable "manifest_admin_client_secret" {
  type = string
}

variable "manifest_auth_tokens" {
  type = string
}

variable "manifest_document_download_api_key" {
  type = string
}

variable "manifest_aws_route53_zone" {
  type = string
}

variable "manifest_aws_ses_access_key" {
  type = string
}

variable "manifest_aws_ses_secret_key" {
  type = string
}

variable "manifest_dangerous_salt" {
  type = string
}

variable "manifest_debug_key" {
  type = string
}

variable "manifest_fresh_desk_product_id" {
  type = string
}

variable "manifest_fresh_desk_api_key" {
  type = string
}

variable "manifest_gc_articles_api_auth_username" {
  type = string
}

variable "manifest_gc_articles_api_auth_password" {
  type = string
}

variable "manifest_mixpanel_project_token" {
  type = string
}

variable "manifest_new_relic_license_key" {
  type = string
}

variable "manifest_crm_github_personal_access_token" {
  type = string
}

variable "manifest_salesforce_username" {
  type = string
}

variable "manifest_salesforce_password" {
  type = string
}

variable "manifest_salesforce_security_token" {
  type = string
}

variable "manifest_salesforce_client_privatekey" {
  type = string
}

variable "manifest_salesforce_engagement_product_id" {
  type = string
}

variable "manifest_salesforce_engagement_record_type" {
  type = string
}

variable "manifest_salesforce_engagement_standard_pricebook_id" {
  type = string
}

variable "manifest_salesforce_generic_account_id" {
  type = string
}

variable "manifest_secret_key" {
  type = string
}

variable "manifest_sendgrid_api_key" {
  type = string
}

variable "manifest_waf_secret" {
  type = string
}

variable "manifest_zendesk_api_key" {
  type = string
}

variable "manifest_zendesk_sell_api_key" {
  type = string
}

variable "manifest_sre_client_secret" {
  type = string
}

variable "manifest_cache_clear_client_secret" {
  type = string
}

variable "manifest_aws_pinpoint_sc_pool_id" {
  type = string
}

variable "manifest_aws_pinpoint_sc_template_ids" {
  type = string
}

variable "manifest_aws_pinpoint_default_pool_id" {
  type = string
}

variable "manifest_sqlalachemy_database_uri" {
  type = string
}

variable "manifest_sqlalachemy_database_reader_uri" {
  type = string
}

variable "manifest_postgres_host" {
  type = string
}

variable "manifest_postgres_sql" {
  type = string
}

variable "manifest_redis_publish_url" {
  type = string
}

variable "manifest_redis_url" {
  type = string
}

variable "manifest_cypress_user_pw_secret" {
  type = string
}

variable "manifest_cypress_auth_client_secret" {
  type = string
}

variable "secrets" {
  type = map(object({
    name  = string
    value = string
  }))
  default = {
    manifest_admin_client_secret = {
      name  = "MANIFEST_ADMIN_CLIENT_SECRET"
      value = var.manifest_admin_client_secret
    }
    manifest_auth_tokens = {
      name  = "MANIFEST_AUTH_TOKENS"
      value = var.manifest_auth_tokens
    }
    manifest_document_download_api_key = {
      name  = "MANIFEST_DOCUMENT_DOWNLOAD_API_KEY"
      value = var.manifest_document_download_api_key
    }
    manifest_aws_route53_zone = {
      name  = "MANIFEST_AWS_ROUTE53_ZONE"
      value = var.manifest_aws_route53_zone
    }
    manifest_aws_ses_access_key = {
      name  = "MANIFEST_AWS_SES_ACCESS_KEY"
      value = var.manifest_aws_ses_access_key
    }
    manifest_aws_ses_secret_key = {
      name  = "MANIFEST_AWS_SES_SECRET_KEY"
      value = var.manifest_aws_ses_secret_key
    }
    manifest_dangerous_salt = {
      name  = "MANIFEST_DANGEROUS_SALT"
      value = var.manifest_dangerous_salt
    }
    manifest_debug_key = {
      name  = "MANIFEST_DEBUG_KEY"
      value = var.manifest_debug_key
    }
    manifest_fresh_desk_product_id = {
      name  = "MANIFEST_FRESH_DESK_PRODUCT_ID"
      value = var.manifest_fresh_desk_product_id
    }
    manifest_fresh_desk_api_key = {
      name  = "MANIFEST_FRESH_DESK_API_KEY"
      value = var.manifest_fresh_desk_api_key
    }
    manifest_gc_articles_api_auth_username = {
      name  = "MANIFEST_GC_ARTICLES_API_AUTH_USERNAME"
      value = var.manifest_gc_articles_api_auth_username
    }
    manifest_gc_articles_api_auth_password = {
      name  = "MANIFEST_GC_ARTICLES_API_AUTH_PASSWORD"
      value = var.manifest_gc_articles_api_auth_password
    }
    manifest_mixpanel_project_token = {
      name  = "MANIFEST_MIXPANEL_PROJECT_TOKEN"
      value = var.manifest_mixpanel_project_token
    }
    manifest_new_relic_license_key = {
      name  = "MANIFEST_NEW_RELIC_LICENSE_KEY"
      value = var.manifest_new_relic_license_key
    }
    manifest_crm_github_personal_access_token = {
      name  = "MANIFEST_CRM_GITHUB_PERSONAL_ACCESS_TOKEN"
      value = var.manifest_crm_github_personal_access_token
    }
    manifest_salesforce_username = {
      name  = "MANIFEST_SALESFORCE_USERNAME"
      value = var.manifest_salesforce_username
    }
    manifest_salesforce_password = {
      name  = "MANIFEST_SALESFORCE_PASSWORD"
      value = var.manifest_salesforce_password
    }
    manifest_salesforce_security_token = {
      name  = "MANIFEST_SALESFORCE_SECURITY_TOKEN"
      value = var.manifest_salesforce_security_token
    }
    manifest_salesforce_client_privatekey = {
      name  = "MANIFEST_SALESFORCE_CLIENT_PRIVATEKEY"
      value = var.manifest_salesforce_client_privatekey
    }
    manifest_salesforce_engagement_product_id = {
      name  = "MANIFEST_SALESFORCE_ENGAGEMENT_PRODUCT_ID"
      value = var.manifest_salesforce_engagement_product_id
    }
    manifest_salesforce_engagement_record_type = {
      name  = "MANIFEST_SALESFORCE_ENGAGEMENT_RECORD_TYPE"
      value = var.manifest_salesforce_engagement_record_type
    }
    manifest_salesforce_engagement_standard_pricebook_id = {
      name  = "MANIFEST_SALESFORCE_ENGAGEMENT_STANDARD_PRICEBOOK_ID"
      value = var.manifest_salesforce_engagement_standard_pricebook_id
    }
    manifest_salesforce_generic_account_id = {
      name  = "MANIFEST_SALESFORCE_GENERIC_ACCOUNT_ID"
      value = var.manifest_salesforce_generic_account_id
    }
    manifest_secret_key = {
      name  = "MANIFEST_SECRET_KEY"
      value = var.manifest_secret_key
    }
    manifest_sendgrid_api_key = {
      name  = "MANIFEST_SENDGRID_API_KEY"
      value = var.manifest_sendgrid_api_key
    }
    manifest_waf_secret = {
      name  = "MANIFEST_WAF_SECRET"
      value = var.manifest_waf_secret
    }
    manifest_zendesk_api_key = {
      name  = "MANIFEST_ZENDESK_API_KEY"
      value = var.manifest_zendesk_api_key
    }
    manifest_zendesk_sell_api_key = {
      name  = "MANIFEST_ZENDESK_SELL_API_KEY"
      value = var.manifest_zendesk_sell_api_key
    }
    manifest_sre_client_secret = {
      name  = "MANIFEST_SRE_CLIENT_SECRET"
      value = var.manifest_sre_client_secret
    }
    manifest_cache_clear_client_secret = {
      name  = "MANIFEST_CACHE_CLEAR_CLIENT_SECRET"
      value = var.manifest_cache_clear_client_secret
    }
    manifest_aws_pinpoint_sc_pool_id = {
      name  = "MANIFEST_AWS_PINPOINT_SC_POOL_ID"
      value = var.manifest_aws_pinpoint_sc_pool_id
    }
    manifest_aws_pinpoint_sc_template_ids = {
      name  = "MANIFEST_AWS_PINPOINT_SC_TEMPLATE_IDS"
      value = var.manifest_aws_pinpoint_sc_template_ids
    }
    manifest_aws_pinpoint_default_pool_id = {
      name  = "MANIFEST_AWS_PINPOINT_DEFAULT_POOL_ID"
      value = var.manifest_aws_pinpoint_default_pool_id
    }
    manifest_sqlalachemy_database_uri = {
      name  = "MANIFEST_SQLALCHEMY_DATABASE_URI"
      value = "postgresql://${var.app_db_user}:${var.app_db_user_password}@${var.database_read_write_proxy_endpoint}/${var.app_db_database_name}"
    }
    manifest_sqlalachemy_database_reader_uri = {
      name  = "MANIFEST_SQLALCHEMY_DATABASE_READER_URI"
      value = "postgresql://${var.app_db_user}:${var.app_db_user_password}@${var.database_read_only_proxy_endpoint}/${var.app_db_database_name}"
    }
    manifest_postgres_host = {
      name  = "MANIFEST_POSTGRES_HOST"
      value = var.postgres_cluster_endpoint
    }
    manifest_postgres_sql = {
      name  = "MANIFEST_POSTGRES_SQL"
      value = "postgresql://${var.app_db_user}:${var.app_db_user_password}@${var.database_read_write_proxy_endpoint}/${var.app_db_database_name}"
    }
    manifest_redis_publish_url = {
      name  = "MANIFEST_REDIS_PUBLISH_URL"
      value = "redis://${var.redis_primary_endpoint_address}"
    }
    manifest_redis_url = {
      name  = "MANIFEST_REDIS_URL"
      value = "redis://${var.redis_primary_endpoint_address}"
    }
    manifest_cypress_user_pw_secret = {
      name  = "MANIFEST_CYPRESS_USER_PW_SECRET"
      value = var.manifest_cypress_user_pw_secret
    }
    manifest_cypress_auth_client_secret = {
      name  = "MANIFEST_CYPRESS_AUTH_CLIENT_SECRET"
      value = var.manifest_cypress_auth_client_secret
    }
  }
}

resource "aws_secretsmanager_secret" "secrets" {
  for_each = var.secrets

  name                    = each.value.name
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "secrets" {
  for_each = var.secrets

  secret_id     = aws_secretsmanager_secret.secrets[each.key].id
  secret_string = each.value.value
}

output "secrets" {
  value = {
    for key, secret in aws_secretsmanager_secret.secrets :
    secret.name => aws_secretsmanager_secret_version.secrets[key].secret_string
  }
}