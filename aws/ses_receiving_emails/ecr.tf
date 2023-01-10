resource "aws_ecr_repository" "ses_receiving_emails" {
  # The :latest tag is used in Staging

  name                 = "notify/ses_receiving_emails"
  image_tag_mutability = "MUTABLE" #tfsec:ignore:AWS078

  image_scanning_configuration {
    scan_on_push = true
  }
}
