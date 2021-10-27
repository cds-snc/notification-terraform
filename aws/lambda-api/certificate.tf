resource "aws_acm_certificate" "api_lambda_certificate" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  tags = {
    CostCenter = var.billing_code
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "api_lambda_dns_validation" {
  zone_id = var.hosted_zone_id

  for_each = {
    for dvo in aws_acm_certificate.api_lambda_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type

  ttl = 60
}

resource "aws_acm_certificate_validation" "api_lambda_certificate_validation" {
  certificate_arn         = aws_acm_certificate.api_lambda_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.api_lambda_dns_validation : record.fqdn]
}

