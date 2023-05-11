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
    CostCenter = "notification-canada-ca-${var.env}"
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
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_route53_record" "notification-canada-ca" {
  count    = var.env != "production" ? 1 : 0
  provider = aws.staging

  allow_overwrite = true
  name            = tolist(aws_acm_certificate.notification-canada-ca.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.notification-canada-ca.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.notification-canada-ca.domain_validation_options)[0].resource_record_type
  zone_id         = var.route_53_zone_arn
  ttl             = 60
}

resource "aws_acm_certificate_validation" "notification-canada-ca" {
  count = var.env != "production" ? 1 : 0

  certificate_arn         = aws_acm_certificate.notification-canada-ca.arn
  validation_record_fqdns = [aws_route53_record.notification-canada-ca[0].fqdn]
}

resource "aws_route53_record" "notification-canada-ca-alt" {
  count    = var.env != "production" ? 1 : 0
  provider = aws.staging

  allow_overwrite = true
  name            = tolist(aws_acm_certificate.notification-canada-ca-alt[0].domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.notification-canada-ca-alt[0].domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.notification-canada-ca-alt[0].domain_validation_options)[0].resource_record_type
  zone_id         = var.route_53_zone_arn
  ttl             = 60
}

resource "aws_acm_certificate_validation" "notification-canada-ca-alt" {
  count = var.env != "production" ? 1 : 0

  certificate_arn         = aws_acm_certificate.notification-canada-ca-alt[0].arn
  validation_record_fqdns = [aws_route53_record.notification-canada-ca-alt[0].fqdn]
}
