resource "aws_ecr_repository" "performance-test" {
  # The :latest tag is used in Staging
  #tfsec:ignore:AWS078

  name                 = "notify/performance-test"
  image_tag_mutability = "MUTABLE" #tfsec:ignore:AWS078

  image_scanning_configuration {
    scan_on_push = true
  }
}
