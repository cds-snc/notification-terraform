resource "aws_ecr_repository" "notify_admin" {
  name                 = "notify/admin"
  image_tag_mutability = "MUTABLE" #tfsec:ignore:AWS078

  image_scanning_configuration {
    scan_on_push = true
  }
}
