resource "aws_route53_record" "assets-notification-CNAME" {

  provider = aws.dns
  zone_id  = var.route53_zone_id
  name     = "assets.${var.domain}"
  type     = "CNAME"
  ttl      = "300"
  records  = [aws_cloudfront_distribution.asset_bucket.domain_name]
}