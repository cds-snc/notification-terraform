resource "aws_route53_record" "notification-canada-ca" {
  count           = var.env == "staging" ? 1 : 0
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.notification-canada-ca.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.notification-canada-ca.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.notification-canada-ca.domain_validation_options)[0].resource_record_type
  zone_id         = aws_route53_zone.notification-sandbox.zone_id
  ttl             = 60
}

resource "aws_acm_certificate_validation" "notification-canada-ca" {
  count                   = var.env == "staging" ? 1 : 0
  certificate_arn         = aws_acm_certificate.notification-canada-ca.arn
  validation_record_fqdns = [aws_route53_record.notification-canada-ca.fqdn]
}

resource "aws_route53_record" "notification-canada-ca-alt" {
  count           = var.env == "staging" ? 1 : 0
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.notification-canada-ca-alt.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.notification-canada-ca-alt.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.notification-canada-ca-alt.domain_validation_options)[0].resource_record_type
  zone_id         = aws_route53_zone.notification-sandbox.zone_id
  ttl             = 60
}

resource "aws_acm_certificate_validation" "notification-canada-ca-alt" {
  count                   = var.env == "staging" ? 1 : 0
  certificate_arn         = aws_acm_certificate.notification-canada-ca-alt.arn
  validation_record_fqdns = [aws_route53_record.notification-canada-ca-alt.fqdn]
}

resource "aws_route53_record" "assets-notification-canada-ca" {
  count           = var.env == "staging" ? 1 : 0
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.assets-notification-canada-ca.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.assets-notification-canada-ca.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.assets-notification-canada-ca.domain_validation_options)[0].resource_record_type
  zone_id         = aws_route53_zone.notification-sandbox.zone_id
  ttl             = 60
}

resource "aws_acm_certificate_validation" "assets-notification-canada-ca" {
  count                   = var.env == "staging" ? 1 : 0
  certificate_arn         = aws_acm_certificate.assets-notification-canada-ca.arn
  validation_record_fqdns = [aws_route53_record.assets-notification-canada-ca.fqdn]
}
