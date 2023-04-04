resource "aws_acm_certificate" "notification-canada-ca" {
  domain_name = var.domain
  subject_alternative_names = [
    "*.${var.domain}",
    "*.api.${var.domain}",
    "api.${var.domain}",
    "*.document.${var.domain}"
  ]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    CostCentre = "notification-canada-ca-${var.env}"
    Terraform  = true
  }
}

resource "aws_acm_certificate" "notification-canada-ca-alt" {
  count = var.alt_domain != "" ? 1 : 0

  domain_name = var.alt_domain
  subject_alternative_names = [
    "*.${var.alt_domain}",
    "*.api.${var.alt_domain}",
    "api.${var.alt_domain}",
    "*.document.${var.alt_domain}"
  ]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    CostCentre = "notification-canada-ca-${var.env}"
    Terraform  = true
  }
}

resource "aws_acm_certificate" "assets-notification-canada-ca" {
  # Cloudfront requires client certificate to be created in us-east-1
  provider          = aws.us-east-1
  domain_name       = "assets.${var.domain}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    CostCentre = "notification-canada-ca-${var.env}"
    Terraform  = true
  }
}
