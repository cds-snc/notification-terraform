###
# ECR — Locust redline load testing
# Kept in this module so it is only deployed alongside the load test infrastructure.
###

resource "aws_ecr_repository" "locust_redline" {
  name                 = "notify/locust-redline"
  image_tag_mutability = "MUTABLE" #tfsec:ignore:AWS078
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}

output "locust_redline_ecr_arn" {
  description = "ARN of the locust-redline ECR repository"
  value       = aws_ecr_repository.locust_redline.arn
}

output "locust_redline_ecr_repository_url" {
  description = "Repository URL of the locust-redline ECR repository"
  value       = aws_ecr_repository.locust_redline.repository_url
}
