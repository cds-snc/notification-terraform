resource "random_string" "perf_test_phone_number_postfix" {
  count   = var.env == "production" || var.env == "staging" ? 0 : 1
  length  = 8
  special = false
}

resource "random_string" "perf_test_email_postfix" {
  count   = var.env == "production" || var.env == "staging" ? 0 : 1
  length  = 8
  special = false
}

resource "random_string" "perf_test_domain_postfix" {
  count   = var.env == "production" || var.env == "staging" ? 0 : 1
  length  = 8
  special = false
}

resource "random_string" "perf_test_auth_header_postfix" {
  count   = var.env == "production" || var.env == "staging" ? 0 : 1
  length  = 8
  special = false
}

resource "aws_secretsmanager_secret" "perf_test_phone_number" {
  name = var.env == "production" || var.env == "staging" ? "perf_test_phone_number" : "perf_test_phone_number_${random_string.perf_test_phone_number_postfix[0].result}"
}

resource "aws_secretsmanager_secret_version" "perf_test_phone_number" {
  secret_id     = aws_secretsmanager_secret.perf_test_phone_number.id
  secret_string = var.perf_test_phone_number
}

resource "aws_secretsmanager_secret" "perf_test_email" {
  name = var.env == "production" || var.env == "staging" ? "perf_test_email" : "perf_test_email${random_string.perf_test_email_postfix[0].result}"
}

resource "aws_secretsmanager_secret_version" "perf_test_email" {
  secret_id     = aws_secretsmanager_secret.perf_test_email.id
  secret_string = var.perf_test_email
}

resource "aws_secretsmanager_secret" "perf_test_domain" {
  name = var.env == "production" || var.env == "staging" ? "perf_test_domain" : "perf_test_domain${random_string.perf_test_auth_header_postfix[0].result}"
}

resource "aws_secretsmanager_secret_version" "perf_test_domain" {
  secret_id     = aws_secretsmanager_secret.perf_test_domain.id
  secret_string = var.perf_test_domain
}

resource "aws_secretsmanager_secret" "perf_test_auth_header" {
  name = var.env == "production" || var.env == "staging" ? "perf_test_auth_header" : "perf_test_auth_header${random_string.perf_test_auth_header_postfix[0].result}"
}

resource "aws_secretsmanager_secret_version" "perf_test_auth_header" {
  secret_id     = aws_secretsmanager_secret.perf_test_auth_header.id
  secret_string = var.perf_test_auth_header
}
