resource "aws_route53_zone" "scratch-notification" {
  name = "scratch.notification.cdssandbox.xyz"
}


resource "aws_route53_record" "nginx" {
  zone_id = aws_route53_zone.scratch-notification.zone_id
  name    = "scratch.notification.cdssandbox.xyz"
  type    = "A"
  ttl     = "30"
  records = ["3.98.221.14"]
}

resource "aws_route53_record" "nginx-cname" {
  zone_id = aws_route53_zone.scratch-notification.zone_id
  name    = "*.scratch.notification.cdssandbox.xyz"
  type    = "CNAME"
  ttl     = "30"
  records = [aws_route53_record.nginx.name]
}
resource "aws_route53_record" "cloudfront-cname" {
  zone_id = aws_route53_zone.scratch-notification.zone_id
  name    = "assets.scratch.notification.cdssandbox.xyz"
  type    = "CNAME"
  ttl     = "30"
  records = ["d198utls97xdrn.cloudfront.net"]
}