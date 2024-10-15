resource "aws_secretsmanager_secret" "ses_receiving_emails_repository_url" {
  name                    = "SES_RECEIVING_EMAILS_REPOSITORY_URL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "ses_receiving_emails_repository_url" {
  secret_id     = aws_secretsmanager_secret.ses_receiving_emails_repository_url.id
  secret_string = aws_ecr_repository.ses_receiving_emails.repository_url
}
