resource "aws_ecr_repository" "ses_receiving_emails" {
  # The :latest tag is used in Staging

  provider             = aws.us-east-1
  name                 = "notify/ses_receiving_emails"
  image_tag_mutability = "MUTABLE" #tfsec:ignore:AWS078
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}