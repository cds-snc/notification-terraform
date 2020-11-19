resource "aws_acm_certificate" "assets-notification-canada" {
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
