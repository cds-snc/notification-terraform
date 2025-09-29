#checkov:skip=CKV2_AWS_38:This is an internal DNS and thus DNSSEC not required
#checkov:skip=CKV2_AWS_39:DNS Query Logging is not supported for internal DNS
resource "aws_route53_zone" "internal_dns" {
  name = "notification.prv"

  vpc {
    vpc_id = var.vpc_id
  }
}

