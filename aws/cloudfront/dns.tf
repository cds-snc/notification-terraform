resource "aws_route53_record" "assets-notification-CNAME" {
  count = var.env != "production" ? 1 : 0

  provider = aws.dns
  zone_id  = var.route_53_zone_arn
  name     = "assets.${var.domain}"
  type     = "CNAME"
  ttl      = "300"
  records  = [aws_cloudfront_distribution.asset_bucket.domain_name]
}