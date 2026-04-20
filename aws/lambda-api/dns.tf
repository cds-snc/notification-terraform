resource "aws_route53_record" "api-lambda-notification-A" {

  provider = aws.dns

  zone_id         = var.route53_zone_id
  name            = "api-lambda.${var.domain}"
  type            = "A"
  allow_overwrite = true

  alias {
    name                   = aws_api_gateway_domain_name.api_lambda.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.api_lambda.regional_zone_id
    evaluate_target_health = true
  }

}

moved {
  from = aws_route53_record.api-weighted-100-notification-A
  to   = aws_route53_record.api-weighted-notification-A
}

resource "aws_route53_record" "api-weighted-notification-A" {
  # Weighted record configured to send 0% of API traffic to Lambda
  provider = aws.dns

  zone_id         = var.route53_zone_id
  name            = "api.${var.domain}"
  type            = "A"
  set_identifier  = "lambda"
  allow_overwrite = true

  alias {
    name                   = aws_api_gateway_domain_name.api.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.api.regional_zone_id
    evaluate_target_health = true
  }

  weighted_routing_policy {
    weight = 0
  }
}

resource "aws_route53_record" "api-notification-alt-A" {
  #TODO: Alt DNS for Prod
  count    = var.env != "production" ? 1 : 0
  provider = aws.dns

  zone_id         = var.route53_zone_id
  name            = "api.${var.alt_domain}"
  type            = "A"
  allow_overwrite = true

  alias {
    name                   = aws_api_gateway_domain_name.api_lambda.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.api_lambda.regional_zone_id
    evaluate_target_health = false
  }

}