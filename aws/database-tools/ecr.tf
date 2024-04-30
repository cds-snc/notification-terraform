resource "aws_ecr_repository" "blazer" {
  name                 = "database-tools/blazer"
  image_tag_mutability = "MUTABLE"
  force_delete         = var.force_delete_ecr
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}
