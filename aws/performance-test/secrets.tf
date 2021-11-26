resource "aws_secretsmanager_secret" "perf_test_phone_number" {
  name = "perf_test_phone_number"
}

resource "aws_secretsmanager_secret_version" "perf_test_phone_number" {
  secret_id     = aws_secretsmanager_secret.perf_test_phone_number.id
  secret_string = var.perf_test_phone_number
}

resource "aws_secretsmanager_secret" "perf_test_email" {
  name = "perf_test_email"
}

resource "aws_secretsmanager_secret_version" "perf_test_email" {
  secret_id     = aws_secretsmanager_secret.perf_test_email.id
  secret_string = var.perf_test_email
}

resource "aws_secretsmanager_secret" "perf_test_domain" {
  name = "perf_test_domain"
}

resource "aws_secretsmanager_secret_version" "perf_test_domain" {
  secret_id     = aws_secretsmanager_secret.perf_test_domain.id
  secret_string = var.perf_test_domain
}

resource "aws_secretsmanager_secret" "test_auth_header" {
  name = "test_auth_header"
}

resource "aws_secretsmanager_secret_version" "test_auth_header" {
  secret_id     = aws_secretsmanager_secret.test_auth_header.id
  secret_string = var.test_auth_header
}
