resource "aws_ecr_repository" "ses_to_sqs_email_callbacks" {
  # The :latest tag is used in Staging

  name                 = "notify/ses_to_sqs_email_callbacks"
  image_tag_mutability = "MUTABLE" #tfsec:ignore:AWS078

  image_scanning_configuration {
    scan_on_push = true
  }
}
