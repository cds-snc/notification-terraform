resource "aws_ecr_repository" "heartbeat" {
  # The :latest tag is used in Staging

  name                 = "notify/heartbeat"
  image_tag_mutability = "MUTABLE" #tfsec:ignore:AWS078

  image_scanning_configuration {
    scan_on_push = true
  }
}
