
resource "aws_secretsmanager_secret" "aws_ses_reigon" {
  name                    = "AWS_SES_REGION"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "aws_ses_reigon" {
  secret_id     = aws_secretsmanager_secret.aws_ses_reigon.id
  secret_string = "us-east-1"
}

resource "aws_secretsmanager_secret" "aws_ses_smtp" {
  name                    = "AWS_SES_SMTP"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "aws_ses_smtp" {
  secret_id     = aws_secretsmanager_secret.aws_ses_smtp.id
  secret_string = "email-smtp.ca-central-1.amazonaws.com"
}

resource "aws_secretsmanager_secret" "ses_access_key" {
  name                    = "AWS_SES_ACCESS_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "ses_access_key" {
  secret_id     = aws_secretsmanager_secret.ses_access_key.id
  secret_string = var.ses_access_key
}

resource "aws_secretsmanager_secret" "ses_secret_key" {
  name                    = "AWS_SES_SECRET_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "ses_secret_key" {
  secret_id     = aws_secretsmanager_secret.ses_secret_key.id
  secret_string = var.ses_secret_key
}
