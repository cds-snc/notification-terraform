resource "aws_secretsmanager_secret" "ses_to_sqs_email_callbacks_repository_url" {
  name                    = "SES_TO_SQS_EMAIL_CALLBACKS_REPOSITORY_URL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "ses_to_sqs_email_callbacks_repository_url" {
  secret_id     = aws_secretsmanager_secret.ses_to_sqs_email_callbacks_repository_url.id
  secret_string = aws_ecr_repository.ses_to_sqs_email_callbacks.repository_url
}


resource "aws_secretsmanager_secret" "sns_to_sqs_sms_callbacks_repository_url" {
  name                    = "SNS_TO_SQS_SMS_CALLBACKS_REPOSITORY_URL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "sns_to_sqs_sms_callbacks_repository_url" {
  secret_id     = aws_secretsmanager_secret.sns_to_sqs_sms_callbacks_repository_url.id
  secret_string = aws_ecr_repository.sns_to_sqs_sms_callbacks.repository_url
}

resource "aws_secretsmanager_secret" "pinpoint_to_sqs_sms_callbacks_repository_url" {
  name                    = "PINPOINT_TO_SQS_SMS_CALLBACKS_REPOSITORY_URL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "pinpoint_to_sqs_sms_callbacks_repository_url" {
  secret_id     = aws_secretsmanager_secret.pinpoint_to_sqs_sms_callbacks_repository_url.id
  secret_string = aws_ecr_repository.pinpoint_to_sqs_sms_callbacks.repository_url
}

resource "aws_secretsmanager_secret" "heartbeat_repository_url" {
  name                    = "HEARTBEAT_REPOSITORY_URL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "heartbeat_repository_url" {
  secret_id     = aws_secretsmanager_secret.heartbeat_repository_url.id
  secret_string = aws_ecr_repository.heartbeat.repository_url
}

resource "aws_secretsmanager_secret" "api_lambda_repository_url" {
  name                    = "API_LAMBDA_REPOSITORY_URL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "api_lambda_repository_url" {
  secret_id     = aws_secretsmanager_secret.api_lambda_repository_url.id
  secret_string = aws_ecr_repository.api-lambda.repository_url
}

resource "aws_secretsmanager_secret" "google_cidr_repository_url" {
  name                    = "GOOGLE_CIDR_REPOSITORY_URL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "google_cidr_repository_url" {
  secret_id     = aws_secretsmanager_secret.google_cidr_repository_url.id
  secret_string = aws_ecr_repository.google-cidr.repository_url
}

resource "aws_secretsmanager_secret" "system_status_repository_url" {
  name                    = "SYSTEM_STATUS_REPOSITORY_URL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "system_status_repository_url" {
  secret_id     = aws_secretsmanager_secret.system_status_repository_url.id
  secret_string = aws_ecr_repository.system_status.repository_url
}