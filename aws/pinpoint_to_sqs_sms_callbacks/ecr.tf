resource "aws_ecr_repository" "pinpoint_to_sqs_sms_callbacks" {
  # The :latest tag is used in Staging

  name                 = "notify/pinpoint_to_sqs_sms_callbacks"
  image_tag_mutability = "MUTABLE" #tfsec:ignore:AWS078
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_secretsmanager_secret" "pinpoint_to_sqs_sms_callbacks_repository_url" {
  name = "PINPOINT_TO_SQS_SMS_CALLBACKS_REPOSITORY_URL"
}

resource "aws_secretsmanager_secret_version" "pinpoint_to_sqs_sms_callbacks_repository_url" {
  secret_id     = aws_secretsmanager_secret.pinpoint_to_sqs_sms_callbacks_repository_url.id
  secret_string = aws_ecr_repository.pinpoint_to_sqs_sms_callbacks.repository_url
}
