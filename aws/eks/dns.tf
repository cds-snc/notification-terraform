resource "aws_route53_record" "notification-root" {
  zone_id = var.route_53_zone_arn
  name    = var.domain
  type    = "A"

  alias {
    name                   = aws_alb.notification-canada-ca.dns_name
    zone_id                = aws_alb.notification-canada-ca.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "notificatio-root-WC" {
  name    = "*.${var.domain}"
  zone_id = var.route_53_zone_arn
  type    = "A"

  alias {
    name                   = aws_alb.notification-canada-ca.dns_name
    zone_id                = aws_alb.notification-canada-ca.zone_id
    evaluate_target_health = false
  }

}