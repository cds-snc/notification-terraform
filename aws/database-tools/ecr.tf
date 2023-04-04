resource "aws_ecr_repository" "blazer" {
  name                 = "database-tools/blazer"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    CostCentre = "notification-canada-ca-${var.env}"
    Terraform  = true
  }
}
