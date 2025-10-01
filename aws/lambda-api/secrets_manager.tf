resource "aws_secretsmanager_secret" "new-relic-license-key" {
  name                    = "NEW_RELIC_LICENSE_KEY"
  description             = "The New Relic license key, for sending telemetry"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "new-relic-license-key" {
  secret_id     = aws_secretsmanager_secret.new-relic-license-key.id
  secret_string = var.new_relic_license_key
}

resource "aws_secretsmanager_secret" "lambda-new-relic-license-key" {
  name                    = "NEW_RELIC_LICENSE_KEY"
  description             = "The New Relic license key, for sending telemetry"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "lambda-new-relic-license-key" {
  secret_id     = aws_secretsmanager_secret.lambda-new-relic-license-key.id
  secret_string = var.manifest_new_relic_license_key
}

resource "aws_ssm_parameter" "environment_variables" {
  count       = var.bootstrap ? 1 : 0
  name        = "ENVIRONMENT_VARIABLES"
  description = "Environment variables for the API Lambda function"
  type        = "SecureString"
  tier        = "Advanced"
  value       = <<EOF
ADMIN_CLIENT_SECRET=${var.manifest_admin_client_secret}
ALLOW_DEBUG_ROUTE=false
ALLOW_HTML_SERVICE_IDS=4de8b784-03a8-4ba8-a440-3bfea1b04fe6,ea608120-148a-4eba-a64c-4d9a8010e7b0
API_HOST_NAME=https://api.${var.base_domain}
ASSET_UPLOAD_BUCKET_NAME=notification-canada-ca-${var.env}-asset-upload
ASSET_DOMAIN=assets.${var.base_domain}
ATTACHMENT_NUM_LIMIT=10
AUTH_TOKENS=${var.manifest_auth_tokens}
DOCUMENT_DOWNLOAD_API_KEY=${var.manifest_document_download_api_key}

AWS_PINPOINT_REGION=us-west-2

AWS_REGION=ca-central-1
AWS_US_TOLL_FREE_NUMBER=+18449521252

AWS_ROUTE53_ZONE=${var.route53_zone_id}
AWS_SES_REGION=us-east-1
AWS_SES_SMTP=email-smtp.us-east-1.amazonaws.com
AWS_SES_ACCESS_KEY=${var.manifest_aws_ses_access_key}
AWS_SES_SECRET_KEY=${var.manifest_aws_ses_secret_key}

BASE_DOMAIN=${var.base_domain}
BATCH_INSERTION_CHUNK_SIZE=10

BULK_SEND_AWS_BUCKET=notification-canada-ca-${var.env}-bulk-send
BULK_SEND_TEST_SERVICE_ID=ea608120-148a-4eba-a64c-4d9a8010e7b0

CELERY_CONCURRENCY=4
CELERY_DELIVER_SMS_RATE_LIMIT=10/s
CONTACT_EMAIL=notification-ops@cds-snc.ca

CSV_UPLOAD_BUCKET_NAME=notification-canada-ca-${var.env}-csv-upload
CLUSTER_NAME=notification-canada-ca-${var.env}-eks-cluster
DANGEROUS_SALT=${var.manifest_dangerous_salt}
DOCUMENTS_BUCKET=notification-canada-ca-${var.env}-document-download
DEBUG_KEY=${var.manifest_debug_key}
ENVIRONMENT=${var.env}
EXTRA_MIME_TYPES=b7b2104c-011f-436a-a25f-3fd66b6591e4:application/octet-stream,b7b2104c-011f-436a-a25f-3fd66b6591e4:application/xml,b7b2104c-011f-436a-a25f-3fd66b6591e4:text/xml,b7b2104c-011f-436a-a25f-3fd66b6591e4:application/json,dea2d718-b7fb-4003-868a-1832fd025d7a:image/svg+xml,d6aa2c68-a2d9-4437-ab19-3ae8eb202553:text/calendar

FF_SALESFORCE_CONTACT=true
FF_RTL=true
FF_ANNUAL_LIMIT=true

FIDO2_DOMAIN=${var.base_domain}
FRESH_DESK_PRODUCT_ID=${var.manifest_fresh_desk_product_id}
FRESH_DESK_API_URL=https://cds-snc.freshdesk.com
FRESH_DESK_API_KEY=${var.manifest_fresh_desk_api_key}
FRESH_DESK_ENABLED=False

GC_ARTICLES_API_AUTH_USERNAME=${var.manifest_gc_articles_api_auth_username}
GC_ARTICLES_API_AUTH_PASSWORD="${var.manifest_gc_articles_api_auth_password}"
GC_ARTICLES_API=articles.alpha.canada.ca/notification-gc-notify
GC_ORGANISATIONS_BUCKET_NAME=notification-canada-ca-${var.env}-gc-organisations

HC_EN_SERVICE_ID=c2fe9fac-2f28-40ca-b152-08ee41cd6843
HC_FR_SERVICE_ID=

IP_GEOLOCATE_SERVICE=http://ipv4.notification-canada-ca.svc.cluster.local:8080

MIXPANEL_PROJECT_TOKEN=${var.manifest_mixpanel_project_token}

NEW_RELIC_LICENSE_KEY=${var.manifest_new_relic_license_key}
NEW_RELIC_MONITOR_MODE=true

POSTGRES_HOST=${var.postgres_cluster_endpoint}
POSTGRES_SQL=postgresql://${var.app_db_user}:${var.app_db_user_password}@${var.database_read_write_proxy_endpoint}/${var.app_db_database_name}

REDIS_URL=redis://${var.redis_primary_endpoint_address}
CACHE_OPS_URL=redis://${var.elasticache_queue_cache_primary_endpoint_address}
REPORTS_BUCKET_NAME=notification-canada-ca-${var.env}-reports

CRM_GITHUB_PERSONAL_ACCESS_TOKEN=${var.manifest_crm_github_personal_access_token}
CRM_ORG_LIST_URL=https://raw.githubusercontent.com/cds-snc/gc-organisations-qa/main/data/all.json

SALESFORCE_USERNAME=${var.manifest_salesforce_username}
SALESFORCE_PASSWORD=${var.manifest_salesforce_password}
SALESFORCE_SECURITY_TOKEN=${var.manifest_salesforce_security_token}
SALESFORCE_CLIENT_PRIVATEKEY=${var.manifest_salesforce_client_privatekey}
SALESFORCE_DOMAIN=test
SALESFORCE_ENGAGEMENT_PRODUCT_ID=${var.manifest_salesforce_engagement_product_id}
SALESFORCE_ENGAGEMENT_RECORD_TYPE=${var.manifest_salesforce_engagement_record_type}
SALESFORCE_ENGAGEMENT_STANDARD_PRICEBOOK_ID=${var.manifest_salesforce_engagement_standard_pricebook_id}
SALESFORCE_GENERIC_ACCOUNT_ID=${var.manifest_salesforce_generic_account_id}

SCAN_FILES_DOCUMENTS_BUCKET=notification-canada-ca-${var.env}-document-download-scan-files
SECRET_KEY=${var.manifest_secret_key}

SENDGRID_API_KEY=${var.manifest_sendgrid_api_key}
SENTRY_URL=https://754db8b4e27045efb8ea40cbad086407@o142744.ingest.sentry.io/1522933

SQLALCHEMY_DATABASE_READER_URI=postgresql://${var.app_db_user}:${var.app_db_user_password}@${var.database_read_write_proxy_endpoint}/${var.app_db_database_name}
SQLALCHEMY_POOL_SIZE=256

WAF_SECRET=${var.manifest_waf_secret}

ZENDESK_API_KEY=${var.manifest_zendesk_api_key}
ZENDESK_API_URL=https://cds-snc.zendesk.com
ZENDESK_SELL_API_KEY=${var.manifest_zendesk_sell_api_key}
ZENDESK_SELL_API_URL=https://api.getbase.com/
SRE_CLIENT_SECRET=${var.manifest_sre_client_secret}
CACHE_CLEAR_CLIENT_SECRET=${var.manifest_cache_clear_client_secret}

AWS_PINPOINT_SC_POOL_ID=${var.manifest_aws_pinpoint_sc_pool_id}
AWS_PINPOINT_SC_TEMPLATE_IDS=${var.manifest_aws_pinpoint_sc_template_ids}
AWS_PINPOINT_DEFAULT_POOL_ID=${var.manifest_aws_pinpoint_default_pool_id}

AWS_XRAY_SDK_ENABLED=true
AWS_XRAY_CONTEXT_MISSING=LOG_WARNING

CYPRESS_USER_PW_SECRET=${var.manifest_cypress_user_pw_secret}
CYPRESS_AUTH_CLIENT_SECRET=${var.manifest_cypress_auth_client_secret}
EOF
}

resource "aws_ssm_parameter" "environment_variables_admin" {
  count       = var.bootstrap ? 1 : 0
  name        = "ENVIRONMENT_VARIABLES_ADMIN"
  description = "Environment variables for the PR ADMIN Lambda function"
  type        = "SecureString"
  tier        = "Advanced"
  value       = <<EOF
ADMIN_CLIENT_SECRET=${var.manifest_admin_client_secret}
ALLOW_DEBUG_ROUTE=false
ALLOW_HTML_SERVICE_IDS=4de8b784-03a8-4ba8-a440-3bfea1b04fe6,ea608120-148a-4eba-a64c-4d9a8010e7b0
API_HOST_NAME=https://api.${var.base_domain}
ASSET_UPLOAD_BUCKET_NAME=notification-canada-ca-${var.env}-asset-upload
ASSET_DOMAIN=assets.${var.base_domain}
ATTACHMENT_NUM_LIMIT=10
AUTH_TOKENS=${var.manifest_auth_tokens}
DOCUMENT_DOWNLOAD_API_KEY=${var.manifest_document_download_api_key}

AWS_PINPOINT_REGION=us-west-2

AWS_REGION=ca-central-1
AWS_US_TOLL_FREE_NUMBER=+18449521252

AWS_ROUTE53_ZONE=${var.route53_zone_id}
AWS_SES_REGION=us-east-1
AWS_SES_SMTP=email-smtp.us-east-1.amazonaws.com
AWS_SES_ACCESS_KEY=${var.manifest_aws_ses_access_key}
AWS_SES_SECRET_KEY=${var.manifest_aws_ses_secret_key}

BASE_DOMAIN=${var.base_domain}
BATCH_INSERTION_CHUNK_SIZE=10

BULK_SEND_AWS_BUCKET=notification-canada-ca-${var.env}-bulk-send
BULK_SEND_TEST_SERVICE_ID=ea608120-148a-4eba-a64c-4d9a8010e7b0

CELERY_CONCURRENCY=4
CELERY_DELIVER_SMS_RATE_LIMIT=10/s
CONTACT_EMAIL=notification-ops@cds-snc.ca

CSV_UPLOAD_BUCKET_NAME=notification-canada-ca-${var.env}-csv-upload
CLUSTER_NAME=notification-canada-ca-${var.env}-eks-cluster
DANGEROUS_SALT=${var.manifest_dangerous_salt}
DOCUMENTS_BUCKET=notification-canada-ca-${var.env}-document-download
DEBUG_KEY=${var.manifest_debug_key}
ENVIRONMENT=${var.env}
EXTRA_MIME_TYPES=b7b2104c-011f-436a-a25f-3fd66b6591e4:application/octet-stream,b7b2104c-011f-436a-a25f-3fd66b6591e4:application/xml,b7b2104c-011f-436a-a25f-3fd66b6591e4:text/xml,b7b2104c-011f-436a-a25f-3fd66b6591e4:application/json,dea2d718-b7fb-4003-868a-1832fd025d7a:image/svg+xml,d6aa2c68-a2d9-4437-ab19-3ae8eb202553:text/calendar

FF_SALESFORCE_CONTACT=true
FF_RTL=true
FF_ANNUAL_LIMIT=true

FIDO2_DOMAIN=${var.base_domain}
FRESH_DESK_PRODUCT_ID=${var.manifest_fresh_desk_product_id}
FRESH_DESK_API_URL=https://cds-snc.freshdesk.com
FRESH_DESK_API_KEY=${var.manifest_fresh_desk_api_key}
FRESH_DESK_ENABLED=False

GC_ARTICLES_API_AUTH_USERNAME=${var.manifest_gc_articles_api_auth_username}
GC_ARTICLES_API_AUTH_PASSWORD="${var.manifest_gc_articles_api_auth_password}"
GC_ARTICLES_API=articles.alpha.canada.ca/notification-gc-notify
GC_ORGANISATIONS_BUCKET_NAME=notification-canada-ca-${var.env}-gc-organisations

HC_EN_SERVICE_ID=c2fe9fac-2f28-40ca-b152-08ee41cd6843
HC_FR_SERVICE_ID=

IP_GEOLOCATE_SERVICE=http://ipv4.notification-canada-ca.svc.cluster.local:8080

MIXPANEL_PROJECT_TOKEN=${var.manifest_mixpanel_project_token}

NEW_RELIC_LICENSE_KEY=${var.manifest_new_relic_license_key}
NEW_RELIC_MONITOR_MODE=true

POSTGRES_HOST=${var.postgres_cluster_endpoint}
POSTGRES_SQL=postgresql://${var.app_db_user}:${var.app_db_user_password}@${var.database_read_write_proxy_endpoint}/${var.app_db_database_name}

REDIS_URL=redis://${var.redis_primary_endpoint_address}
REDIS_PUBLISH_URL=redis://${var.redis_primary_endpoint_address}
REPORTS_BUCKET_NAME=notification-canada-ca-${var.env}-reports

CRM_GITHUB_PERSONAL_ACCESS_TOKEN=${var.manifest_crm_github_personal_access_token}
CRM_ORG_LIST_URL=https://raw.githubusercontent.com/cds-snc/gc-organisations-qa/main/data/all.json

SALESFORCE_USERNAME=${var.manifest_salesforce_username}
SALESFORCE_PASSWORD=${var.manifest_salesforce_password}
SALESFORCE_SECURITY_TOKEN=${var.manifest_salesforce_security_token}
SALESFORCE_CLIENT_PRIVATEKEY=${var.manifest_salesforce_client_privatekey}
SALESFORCE_DOMAIN=test
SALESFORCE_ENGAGEMENT_PRODUCT_ID=${var.manifest_salesforce_engagement_product_id}
SALESFORCE_ENGAGEMENT_RECORD_TYPE=${var.manifest_salesforce_engagement_record_type}
SALESFORCE_ENGAGEMENT_STANDARD_PRICEBOOK_ID=${var.manifest_salesforce_engagement_standard_pricebook_id}
SALESFORCE_GENERIC_ACCOUNT_ID=${var.manifest_salesforce_generic_account_id}

SCAN_FILES_DOCUMENTS_BUCKET=notification-canada-ca-${var.env}-document-download-scan-files
SECRET_KEY=${var.manifest_secret_key}

SENDGRID_API_KEY=${var.manifest_sendgrid_api_key}
SENTRY_URL=https://754db8b4e27045efb8ea40cbad086407@o142744.ingest.sentry.io/1522933

SQLALCHEMY_DATABASE_READER_URI=postgresql://${var.app_db_user}:${var.app_db_user_password}@${var.database_read_write_proxy_endpoint}/${var.app_db_database_name}
SQLALCHEMY_POOL_SIZE=256

WAF_SECRET=${var.manifest_waf_secret}

ZENDESK_API_KEY=${var.manifest_zendesk_api_key}
ZENDESK_API_URL=https://cds-snc.zendesk.com
ZENDESK_SELL_API_KEY=${var.manifest_zendesk_sell_api_key}
ZENDESK_SELL_API_URL=https://api.getbase.com/
SRE_CLIENT_SECRET=${var.manifest_sre_client_secret}
CACHE_CLEAR_CLIENT_SECRET=${var.manifest_cache_clear_client_secret}

AWS_PINPOINT_SC_POOL_ID=${var.manifest_aws_pinpoint_sc_pool_id}
AWS_PINPOINT_SC_TEMPLATE_IDS=${var.manifest_aws_pinpoint_sc_template_ids}
AWS_PINPOINT_DEFAULT_POOL_ID=${var.manifest_aws_pinpoint_default_pool_id}

AWS_XRAY_SDK_ENABLED=true
AWS_XRAY_CONTEXT_MISSING=LOG_WARNING

CYPRESS_USER_PW_SECRET=${var.manifest_cypress_user_pw_secret}
CYPRESS_AUTH_CLIENT_SECRET=${var.manifest_cypress_auth_client_secret}
EOF
}
