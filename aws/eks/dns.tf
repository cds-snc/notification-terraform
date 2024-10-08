resource "aws_route53_record" "notification-root" {

  provider        = aws.dns
  zone_id         = var.route53_zone_id
  name            = var.domain
  type            = "A"
  allow_overwrite = true

  alias {
    name                   = aws_alb.notification-canada-ca.dns_name
    zone_id                = aws_alb.notification-canada-ca.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "notification-www-root" {

  provider        = aws.dns
  zone_id         = var.route53_zone_id
  name            = "www.${var.domain}"
  type            = "CNAME"
  allow_overwrite = true

  records = [
    aws_alb.notification-canada-ca.dns_name
  ]
  ttl = "300"
}


resource "aws_route53_record" "notificatio-root-WC" {

  provider        = aws.dns
  name            = "*.${var.domain}"
  zone_id         = var.route53_zone_id
  type            = "A"
  allow_overwrite = true

  alias {
    name                   = aws_alb.notification-canada-ca.dns_name
    zone_id                = aws_alb.notification-canada-ca.zone_id
    evaluate_target_health = false
  }

}

resource "aws_route53_record" "doc-notification-canada-ca-cname" {
  provider        = aws.dns
  zone_id         = var.route53_zone_id
  name            = "doc.${var.domain}"
  type            = "CNAME"
  allow_overwrite = true

  records = [
    aws_alb.notification-canada-ca.dns_name
  ]
  ttl = "300"
}

resource "aws_route53_record" "document-notification-canada-ca-cname" {
  provider        = aws.dns
  zone_id         = var.route53_zone_id
  name            = "document.${var.domain}"
  type            = "CNAME"
  allow_overwrite = true


  records = [
    aws_alb.notification-canada-ca.dns_name
  ]
  ttl = "300"
}

resource "aws_route53_record" "api-document-notification-canada-ca-cname" {
  provider        = aws.dns
  zone_id         = var.route53_zone_id
  name            = "api.document.${var.domain}"
  type            = "CNAME"
  allow_overwrite = true

  records = [
    aws_alb.notification-canada-ca.dns_name
  ]
  ttl = "300"
}

resource "aws_route53_record" "documentation-notification-canada-ca-cname" {
  provider        = aws.dns
  zone_id         = var.route53_zone_id
  name            = "documentation.${var.domain}"
  type            = "CNAME"
  allow_overwrite = true

  records = [
    aws_alb.notification-canada-ca.dns_name
  ]
  ttl = "300"
}

resource "aws_route53_record" "notification-alt-root" {
  #TODO: For production
  count           = var.env != "production" ? 1 : 0
  provider        = aws.dns
  zone_id         = var.route53_zone_id
  name            = var.alt_domain
  type            = "A"
  allow_overwrite = true

  alias {
    name                   = aws_alb.notification-canada-ca.dns_name
    zone_id                = aws_alb.notification-canada-ca.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "notification-alt-root-WC" {
  #TODO: For production
  count           = var.env != "production" ? 1 : 0
  provider        = aws.dns
  name            = "*.${var.alt_domain}"
  zone_id         = var.route53_zone_id
  type            = "A"
  allow_overwrite = true

  alias {
    name                   = aws_alb.notification-canada-ca.dns_name
    zone_id                = aws_alb.notification-canada-ca.zone_id
    evaluate_target_health = false
  }

}


resource "aws_route53_record" "api-k8s-scratch-notification-CNAME" {
  provider        = aws.dns
  zone_id         = var.route53_zone_id
  name            = "api-k8s.${var.domain}"
  type            = "CNAME"
  ttl             = "300"
  allow_overwrite = true

  records = [aws_alb.notification-canada-ca.dns_name]
}

resource "aws_route53_record" "api-weighted-0-scratch-notification-A" {
  # Send no API traffic to K8s
  provider        = aws.dns
  zone_id         = var.route53_zone_id
  name            = "api.${var.domain}"
  type            = "A"
  set_identifier  = "loadbalancer"
  allow_overwrite = true

  alias {
    name                   = aws_alb.notification-canada-ca.dns_name
    zone_id                = aws_alb.notification-canada-ca.zone_id
    evaluate_target_health = true
  }

  weighted_routing_policy {
    weight = 0
  }
}

# Dev Tools DNS

resource "aws_route53_record" "notification_internal_dns" {
  zone_id         = var.internal_dns_zone_id
  name            = var.internal_dns_name
  type            = "A"
  allow_overwrite = true

  alias {
    name = aws_lb.internal_alb.dns_name
    # This Zone Id is an AWS system zone and common accross accounts
    zone_id                = "ZQSVJUPU6J1EY"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "wildcard_CNAME" {
  zone_id         = var.internal_dns_zone_id
  name            = "*.${var.internal_dns_name}"
  type            = "CNAME"
  ttl             = "60"
  records         = [var.internal_dns_name]
  allow_overwrite = true
}

