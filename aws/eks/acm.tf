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

  provider = aws.dns

  for_each = {
    for dvo in aws_acm_certificate.notification-canada-ca.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = false
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  ttl             = 300
  zone_id         = var.route53_zone_id

}

resource "aws_acm_certificate_validation" "notification-canada-ca" {

  count = var.env != "production" ? 1 : 0

  depends_on = [aws_route53_record.notification-canada-ca]

  certificate_arn         = aws_acm_certificate.notification-canada-ca.arn
  validation_record_fqdns = [for record in aws_route53_record.notification-canada-ca : record.fqdn]

}

resource "aws_route53_record" "notification-canada-ca-alt" {

  provider = aws.dns

  for_each = {
    for dvo in aws_acm_certificate.notification-canada-ca-alt[0].domain_validation_options : dvo.domain_name => {
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
  zone_id         = var.route53_zone_id

}

resource "aws_acm_certificate_validation" "notification-canada-ca-alt" {

  count = var.env != "production" ? 1 : 0

  depends_on = [aws_route53_record.notification-canada-ca-alt]

  certificate_arn         = aws_acm_certificate.notification-canada-ca-alt[0].arn
  validation_record_fqdns = [for record in aws_route53_record.notification-canada-ca-alt : record.fqdn]
}
