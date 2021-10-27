resource "aws_route53_record" "api_lambda_A" {
  # checkov:skip=CKV2_AWS_23: False-positive, record is attached to API gateway domain name

  zone_id = var.hosted_zone_id
  name    = var.api_lambda_domain_name
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.api.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.api.regional_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_health_check" "api_lambda" {
  fqdn              = var.api_lambda_domain_name
  port              = 443
  type              = "HTTPS"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"
}
