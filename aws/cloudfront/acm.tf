
resource "aws_acm_certificate" "assets-notification-canada-ca" {
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

resource "aws_route53_record" "assets-notification-canada-ca" {
  count           = var.env != "production" ? 1 : 0
  provider        = aws.dns
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.assets-notification-canada-ca.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.assets-notification-canada-ca.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.assets-notification-canada-ca.domain_validation_options)[0].resource_record_type
  zone_id         = var.route53_zone_id
  ttl             = 60
}



resource "aws_acm_certificate_validation" "assets-notification-canada-ca" {
  count                   = var.env != "production" ? 1 : 0
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.assets-notification-canada-ca.arn
  validation_record_fqdns = [aws_route53_record.assets-notification-canada-ca[0].fqdn]
}

