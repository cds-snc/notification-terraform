
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

  provider = aws.staging

  for_each = {
    for dvo in aws_acm_certificate.assets-notification-canada-ca.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  ttl             = 60
  zone_id         = var.route_53_zone_arn

}


resource "aws_acm_certificate_validation" "assets-notification-canada-ca" {
  for_each = aws_route53_record.assets-notification-canada-ca

  certificate_arn         = aws_acm_certificate.assets-notification-canada-ca.arn
  validation_record_fqdns = [each.value.fqdn]
}