resource "aws_route53_record" "api-lambda-notification-sandbox-A" {
  count   = var.env != "production" ? 1 : 0
  zone_id = var.route_53_zone_arn
  name    = "api-lambda.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.api_lambda.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.api_lambda.regional_zone_id
    evaluate_target_health = false
  }

}

resource "aws_route53_record" "api-weighted-100-notification-sandbox-A" {
  # Send all API traffic to Lambda
  count          = var.env != "production" ? 1 : 0
  zone_id        = var.route_53_zone_arn
  name           = "api.${var.domain}"
  type           = "A"
  set_identifier = "lambda"

  alias {
    name                   = aws_api_gateway_domain_name.api_lambda.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.api_lambda.regional_zone_id
    evaluate_target_health = false
  }

  weighted_routing_policy {
    weight = 100
  }
}