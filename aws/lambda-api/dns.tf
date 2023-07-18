resource "aws_route53_record" "api-lambda-notification-A" {

  provider = aws.dns

  zone_id = var.route_53_zone_arn
  name    = "api-lambda.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.api_lambda.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.api_lambda.regional_zone_id
    evaluate_target_health = true
  }

}

resource "aws_route53_record" "api-weighted-100-notification-A" {
  # Send all API traffic to Lambda
  provider = aws.dns

  zone_id        = var.route_53_zone_arn
  name           = "api.${var.domain}"
  type           = "A"
  set_identifier = "lambda"

  alias {
    name                   = aws_api_gateway_domain_name.api_lambda.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.api_lambda.regional_zone_id
    evaluate_target_health = true
  }

  weighted_routing_policy {
    weight = 100
  }
}

resource "aws_route53_record" "api-notification-alt-A" {
  #TODO: Alt DNS for Prod
  count    = var.env != "production" ? 1 : 0
  provider = aws.staging

  zone_id = var.route_53_zone_arn
  name    = "api.${var.alt_domain}"
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.api_lambda.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.api_lambda.regional_zone_id
    evaluate_target_health = false
  }

}