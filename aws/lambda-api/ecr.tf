resource "aws_ecr_repository" "api-lambda" {
  # The :latest tag is used in Staging
  #tfsec:ignore:AWS078

  name                 = "notify/api-lambda"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
