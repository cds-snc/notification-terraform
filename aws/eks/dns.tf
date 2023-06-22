resource "aws_route53_record" "notification-root" {
  count    = var.env != "production" ? 1 : 0
  provider = aws.staging
  zone_id  = var.route_53_zone_arn
  name     = var.base_domain
  type     = "A"

  alias {
    name                   = aws_alb.notification-canada-ca.dns_name
    zone_id                = aws_alb.notification-canada-ca.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "notificatio-root-WC" {
  count    = var.env != "production" ? 1 : 0
  provider = aws.staging
  name     = "*.${var.base_domain}"
  zone_id  = var.route_53_zone_arn
  type     = "A"

  alias {
    name                   = aws_alb.notification-canada-ca.dns_name
    zone_id                = aws_alb.notification-canada-ca.zone_id
    evaluate_target_health = false
  }

}

resource "aws_route53_record" "notification-alt-root" {
  count    = var.env != "production" ? 1 : 0
  provider = aws.staging
  zone_id  = var.route_53_zone_arn
  name     = var.alt_base_domain
  type     = "A"

  alias {
    name                   = aws_alb.notification-canada-ca.dns_name
    zone_id                = aws_alb.notification-canada-ca.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "notification-alt-root-WC" {
  count    = var.env != "production" ? 1 : 0
  provider = aws.staging
  name     = "*.${var.alt_base_domain}"
  zone_id  = var.route_53_zone_arn
  type     = "A"

  alias {
    name                   = aws_alb.notification-canada-ca.dns_name
    zone_id                = aws_alb.notification-canada-ca.zone_id
    evaluate_target_health = false
  }

}


resource "aws_route53_record" "api-k8s-scratch-notification-CNAME" {
  count    = var.env != "production" ? 1 : 0
  provider = aws.staging
  zone_id  = var.route_53_zone_arn
  name     = "api-k8s.${var.base_domain}"
  type     = "CNAME"
  ttl      = "60"
  records  = [aws_alb.notification-canada-ca.dns_name]
}

resource "aws_route53_record" "api-weighted-0-scratch-notification-A" {
  # Send no API traffic to K8s
  count          = var.env != "production" ? 1 : 0
  provider       = aws.staging
  zone_id        = var.route_53_zone_arn
  name           = "api.${var.base_domain}"
  type           = "A"
  set_identifier = "loadbalancer"

  alias {
    name                   = aws_alb.notification-canada-ca.dns_name
    zone_id                = aws_alb.notification-canada-ca.zone_id
    evaluate_target_health = false
  }

  weighted_routing_policy {
    weight = 0
  }
}
