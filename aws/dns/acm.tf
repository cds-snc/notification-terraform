resource "aws_acm_certificate" "notification-canada-ca" {
  domain_name = var.domain
  subject_alternative_names = [
    "*.${var.domain}",
    "*.document.${var.domain}"
  ]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

