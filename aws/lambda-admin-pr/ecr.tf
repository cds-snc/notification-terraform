resource "aws_ecr_repository" "notify_admin" {
  #tfsec:ignore:AWS078

  name                 = "notify/admin"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
