resource "aws_route53_record" "assets-notification-CNAME" {
  zone_id = var.route_53_zone_arn
  name    = "assets.${var.domain}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_cloudfront_distribution.asset_bucket.domain_name]
}