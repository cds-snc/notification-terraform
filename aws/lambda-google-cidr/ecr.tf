resource "aws_ecr_repository" "google-cidr" {
  # The :latest tag is used in Staging

  name                 = "lambda/google-cidr"
  image_tag_mutability = "MUTABLE" #tfsec:ignore:AWS078

  image_scanning_configuration {
    scan_on_push = true
  }
}
