resource "aws_ecr_repository" "api" {
  # checkov:skip=CKV_AWS_51:The :latest tag is used in Staging

  name                 = "${var.product_name}/api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}