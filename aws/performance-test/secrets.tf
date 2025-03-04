resource "random_string" "perf_test_phone_number_postfix" {
  count   = var.env == "staging" ? 0 : 1
  length  = 8
  special = false
}

resource "random_string" "perf_test_email_postfix" {
  count   = var.env == "staging" ? 0 : 1
  length  = 8
  special = false
}

resource "random_string" "perf_test_domain_postfix" {
  count   = var.env == "staging" ? 0 : 1
  length  = 8
  special = false
}

resource "random_string" "perf_test_api_key_postfix" {
  count   = var.env == "staging" ? 0 : 1
  length  = 8
  special = false
}

resource "random_string" "perf_test_slack_webhook_postfix" {
  count   = var.env == "staging" ? 0 : 1
  length  = 8
  special = false
}

resource "random_string" "perf_test_database_uri_postfix" {
  count   = var.env == "staging" ? 0 : 1
  length  = 8
  special = false
}

resource "aws_secretsmanager_secret" "perf_test_phone_number" {
  count                   = var.env == "production" ? 0 : 1
  name                    = var.env == "staging" ? "perf_test_phone_number" : "perf_test_phone_number_${random_string.perf_test_phone_number_postfix[0].result}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "perf_test_phone_number" {
  count         = var.env == "production" ? 0 : 1
  secret_id     = aws_secretsmanager_secret.perf_test_phone_number[0].id
  secret_string = var.perf_test_phone_number
}

resource "aws_secretsmanager_secret" "perf_test_email" {
  count                   = var.env == "production" ? 0 : 1
  name                    = var.env == "staging" ? "perf_test_email" : "perf_test_email${random_string.perf_test_email_postfix[0].result}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "perf_test_email" {
  count         = var.env == "production" ? 0 : 1
  secret_id     = aws_secretsmanager_secret.perf_test_email[0].id
  secret_string = var.perf_test_email
}

resource "aws_secretsmanager_secret" "perf_test_domain" {
  count                   = var.env == "production" ? 0 : 1
  name                    = var.env == "staging" ? "perf_test_domain" : "perf_test_domain${random_string.perf_test_domain_postfix[0].result}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "perf_test_domain" {
  count         = var.env == "production" ? 0 : 1
  secret_id     = aws_secretsmanager_secret.perf_test_domain[0].id
  secret_string = var.perf_test_domain
}

resource "aws_secretsmanager_secret" "perf_test_api_key" {
  count                   = var.env == "production" ? 0 : 1
  name                    = var.env == "staging" ? "perf_test_api_key" : "perf_test_api_key${random_string.perf_test_api_key_postfix[0].result}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "perf_test_api_key" {
  count         = var.env == "production" ? 0 : 1
  secret_id     = aws_secretsmanager_secret.perf_test_api_key[0].id
  secret_string = var.perf_test_api_key
}

resource "aws_secretsmanager_secret" "perf_test_slack_webhook" {
  count                   = var.env == "production" ? 0 : 1
  name                    = var.env == "staging" ? "perf_test_slack_webhook" : "perf_test_slack_webhook${random_string.perf_test_slack_webhook_postfix[0].result}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "perf_test_slack_webhook" {
  count         = var.env == "production" ? 0 : 1
  secret_id     = aws_secretsmanager_secret.perf_test_slack_webhook[0].id
  secret_string = var.perf_test_slack_webhook
}

resource "aws_secretsmanager_secret" "perf_test_database_uri" {
  count                   = var.env == "production" ? 0 : 1
  name                    = var.env == "staging" ? "perf_test_database_uri" : "perf_test_database_uri${random_string.perf_test_database_uri_postfix[0].result}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "perf_test_database_uri" {
  count         = var.env == "production" ? 0 : 1
  secret_id     = aws_secretsmanager_secret.perf_test_database_uri[0].id
  secret_string = "postgresql://${var.app_db_user}:${var.app_db_user_password}@${var.database_read_only_proxy_endpoint}/${var.app_db_database_name}"
}
