resource "aws_secretsmanager_secret" "aws_account_id" {
  provider                = aws.core_services
  name                    = "AWS_ACCOUNT_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "aws_account_id" {
  provider      = aws.core_services
  secret_id     = aws_secretsmanager_secret.aws_account_id.id
  secret_string = var.account_id
}
