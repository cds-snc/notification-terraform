resource "aws_acm_certificate" "notification-canada-ca" {
  domain_name = var.domain
  subject_alternative_names = [
    "*.${var.domain}",
    "*.document.${var.domain}"
  ]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
    # TF bug on AWS 2.0: prevents certificates from being destroyed/recreated
    # https://github.com/hashicorp/terraform-provider-aws/issues/8531
    ignore_changes = [subject_alternative_names]
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_acm_certificate" "notification-canada-ca-alt" {
  count = var.alt_domain != "" ? 1 : 0

  domain_name = var.alt_domain
  subject_alternative_names = [
    "*.${var.alt_domain}",
    "*.document.${var.alt_domain}"
  ]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
    # TF bug on AWS 2.0: prevents certificates from being destroyed/recreated
    # https://github.com/hashicorp/terraform-provider-aws/issues/8531
    ignore_changes = [subject_alternative_names]
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_acm_certificate" "assets" {
  # Cloudfront requires client certificate to be created in us-east-1
  provider          = aws.us-east-1
  domain_name       = "assets.${var.domain}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}
