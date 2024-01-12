#checkov:skip=CKV2_AWS_38:This is an internal DNS and thus DNSSEC not required
#checkov:skip=CKV2_AWS_39:DNS Query Logging is not supported for internal DNS
resource "aws_route53_zone" "dev_internal_dns" {
  count = var.env == "dev" ? 1 : 0
  name  = "dev.notification.internal"

  vpc {
    vpc_id = var.vpc_id
  }
}

# Dev Tools DNS

resource "aws_route53_record" "pgadmin_internal_CNAME" {
  count   = var.env == "dev" ? 1 : 0
  zone_id = aws_route53_zone.dev_internal_dns[0].zone_id
  name    = "pgadmin.dev.notification.internal"
  type    = "CNAME"
  ttl     = "60"
  records = ["internal-a83839c0acb264ff7b00f69e94dc3ca3-2136659269.ca-central-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "graylog_internal_CNAME" {
  count   = var.env == "dev" ? 1 : 0
  zone_id = aws_route53_zone.dev_internal_dns[0].zone_id
  name    = "graylog.dev.notification.internal"
  type    = "CNAME"
  ttl     = "60"
  records = ["internal-a82ca1c11dea44ac5a264c3615f1b2cf-1155384976.ca-central-1.elb.amazonaws.com"]
}

