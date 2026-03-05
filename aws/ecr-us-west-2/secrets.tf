resource "aws_secretsmanager_secret" "pinpoint_to_sqs_sms_callbacks_us_west_2_repository_url" {
  provider                = aws.us-west-2
  name                    = "PINPOINT_TO_SQS_SMS_CALLBACKS_US_WEST_2_REPOSITORY_URL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "pinpoint_to_sqs_sms_callbacks_us_west_2_repository_url" {
  provider  = aws.us-west-2
  secret_id = aws_secretsmanager_secret.pinpoint_to_sqs_sms_callbacks_us_west_2_repository_url.id
  secret_string = aws_ecr_repository.pinpoint_to_sqs_sms_callbacks.repository_url
}
