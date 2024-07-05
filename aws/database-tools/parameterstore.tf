################################################################################
# Secrets - Database tools DB
################################################################################

resource "aws_ssm_parameter" "db_tools_environment_variables" {
  name  = "BLAZER_DATABASE_URL"
  type  = "SecureString"
  value = "postgres://postgres:${var.dbtools_password}@${aws_db_instance.database-tools.address}:5432"

  tags = {
    CostCenter            = "notification-canada-ca-${var.env}"
    Terraform             = true
  }
}

resource "aws_ssm_parameter" "notify_o11y_google_oauth_client_id" {
  name  = "notify_o11y_google_oauth_client_id"
  type  = "SecureString"
  value = var.notify_o11y_google_oauth_client_id

  tags = {
    CostCenter            = "notification-canada-ca-${var.env}"
    Terraform             = true
  }
}

resource "aws_ssm_parameter" "notify_o11y_google_oauth_client_secret" {
  name  = "notify_o11y_google_oauth_client_secret"
  type  = "SecureString"
  value = var.notify_o11y_google_oauth_client_secret

  tags = {
    CostCenter            = "notification-canada-ca-${var.env}"
    Terraform             = true
  }
}

resource "aws_ssm_parameter" "sqlalchemy_database_reader_uri" {
  name  = "sqlalchemy_database_reader_uri"
  type  = "SecureString"
  value = "postgresql://app_db_user:${var.app_db_user_password}@${var.database_read_only_proxy_endpoint}/NotificationCanadaCa${var.env}"

  tags = {
    CostCenter            = "notification-canada-ca-${var.env}"
    Terraform             = true
  }
}
