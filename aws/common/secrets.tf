resource "aws_secretsmanager_secret" "aws_account_id" {
  name                    = "AWS_ACCOUNT_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "aws_account_id" {
  secret_id     = aws_secretsmanager_secret.aws_account_id.id
  secret_string = var.account_id
}

resource "aws_secretsmanager_secret" "aws_pinpoint_region" {
  name                    = "AWS_PINPOINT_REGION"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "aws_pinpoint_region" {
  secret_id     = aws_secretsmanager_secret.aws_pinpoint_region.id
  secret_string = var.aws_pinpoint_region
}

