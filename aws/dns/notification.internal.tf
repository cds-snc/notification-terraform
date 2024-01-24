#checkov:skip=CKV2_AWS_38:This is an internal DNS and thus DNSSEC not required
#checkov:skip=CKV2_AWS_39:DNS Query Logging is not supported for internal DNS
resource "aws_route53_zone" "internal_dns" {
  name = "${var.env}.notification.internal"

  vpc {
    vpc_id = var.vpc_id
  }
}

# Dev Tools DNS

resource "aws_route53_record" "notification-canada-ca-ALIAS" {
  zone_id = aws_route53_zone.internal_dns.zone_id
  name    = "${var.env}.notification.internal"
  type    = "A"

  alias {
    name = var.nginx_internal_ip
    # This Zone Id is an AWS system zone and common accross accounts
    zone_id                = "ZQSVJUPU6J1EY"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "wildcard_CNAME" {
  zone_id = aws_route53_zone.internal_dns.zone_id
  name    = "*.${var.env}.notification.internal"
  type    = "CNAME"
  ttl     = "60"
  records = ["${var.env}.notification.internal"]
}