variable "admin_client_secret" {
  type = string
}

variable "aws_ses_access_key" {
  type = string
}

variable "aws_ses_secret_key" {
  type = string
}
variable "crm_github_personal_access_token" {
  type = string
}
variable "debug_key" {
  type = string
}
variable "dangerous_salt" {
  type = string
}
variable "postgres_host" {
  type = string
}
variable "redis_url" {
  type = string
}

variable "salesforce_engagement_product_id" {
  type = string
}
variable "salesforce_engagement_record_type" {
  type = string
}
variable "salesforce_engagement_standard_pricebook_id" {
  type = string
}
variable "salesforce_generic_account_id" {
  type = string
}
variable "salesforce_username" {
  type = string
}
variable "salesforce_password" {
  type = string
}
variable "salesforce_security_token" {
  type = string
}
variable "salesforce_client_privatekey" {
  type = string
}
variable "secret_key" {
  type = string
}

variable "sendgrid_api_key" {
  type = string
}

variable "app_db_user_password" {
  type = string
}

variable "database_read_only_proxy_endpoint" {
  type = string
}

variable "database_read_write_proxy_endpoint" {
  type = string
}

variable "database_name" {
  type = string
}

variable "twilio_account_sid" {
  type = string
}
variable "twilio_auth_token" {
  type = string
}
variable "twilio_from_number" {
  type = string
}
variable "zendesk_api_key" {
  type = string
}
variable "zendesk_sell_api_key" {
  type = string
}
variable "fresh_desk_product_id" {
  type = string
}
variable "fresh_desk_api_key" {
  type = string
}
variable "hc_en_service_id" {
  type = string
}
variable "hc_fr_service_id" {
  type = string
}
variable "sre_client_secret" {
  type = string
}

variable "sentry_url" {
  type = string
}
variable "new_relic_license_key" {
  type = string
}
variable "mixpanel_project_token" {
  type = string
}
variable "sensitive_services" {
  type = string
}

variable "gc_articles_api_auth_username" {
  type = string
}
variable "gc_articles_api_auth_password" {
  type = string
}
variable "waf_secret" {
  type = string
}

variable "hasura_access_key" {
  type = string
}

variable "auth_tokens" {
  type = string
}

variable "api_target_group_arn" {
  type = string
}
variable "admin_target_group_arn" {
  type = string
}
variable "document_api_target_group_arn" {
  type = string
}
variable "documentation_target_group_arn" {
  type = string
}
variable "document_target_group_arn" {
  type = string
}