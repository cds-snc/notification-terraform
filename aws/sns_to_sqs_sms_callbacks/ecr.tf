resource "aws_ecr_repository" "sns_to_sqs_sms_callbacks" {
  # The :latest tag is used in Staging

  name                 = "notify/sns_to_sqs_sms_callbacks"
  image_tag_mutability = "MUTABLE" #tfsec:ignore:AWS078

  image_scanning_configuration {
    scan_on_push = true
  }
}
