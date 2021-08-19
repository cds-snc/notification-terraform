resource "aws_ecr_repository" "api" {
  # The :latest tag is used in Staging
  #tfsec:ignore:AWS078

  name                 = "${var.product_name}/api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}