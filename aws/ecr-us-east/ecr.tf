resource "aws_ecr_repository" "ses_receiving_emails" {
  provider             = aws.core_services_us_east_1
  name                 = "notify/ses_receiving_emails"
  image_tag_mutability = var.env == "dev" ? "IMMUTABLE" : "MUTABLE" #tfsec:ignore:AWS078
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}