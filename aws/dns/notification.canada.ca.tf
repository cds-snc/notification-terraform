resource "aws_route53_zone" "notification-canada-ca" {
  count = var.env == "production" ? 1 : 0
  name  = "notification.canada.ca"
}

resource "aws_route53_record" "notification-canada-ca-ACM-cname" {
  count   = var.env == "production" ? 1 : 0
  zone_id = aws_route53_zone.notification-canada-ca[0].zone_id
  name    = "_2115a5004ab7895234c60254e152046b.notification.canada.ca"
  type    = "CNAME"
  records = [
    "_aaacd89cd470de0970c70c7ab1b7d4d5.wggjkglgrm.acm-validations.aws."
  ]
  ttl = "60"
}

resource "aws_route53_record" "document-notification-canada-ca-ACM-cname" {
  count   = var.env == "production" ? 1 : 0
  zone_id = aws_route53_zone.notification-canada-ca[0].zone_id
  name    = "_db43d1cf891afd4671fb913d18ef0a0e.document.notification.canada.ca"
  type    = "CNAME"
  records = [
    "_130ea19fa1fdd9e59b7632fbac0d7e00.wggjkglgrm.acm-validations.aws."
  ]
  ttl = "60"
}

resource "aws_route53_record" "api-notification-canada-ca-ACM-cname" {
  count   = var.env == "production" ? 1 : 0
  zone_id = aws_route53_zone.notification-canada-ca[0].zone_id
  name    = "_902cdb1a2cb8214fc698261ee3085b64.api.notification.canada.ca."
  type    = "CNAME"
  records = [
    "_ac309158c158035bfb929da1617e2b16.mqzgcdqkwq.acm-validations.aws."
  ]
  ttl = "60"
}

resource "aws_route53_record" "assets-notification-canada-ca-ACM-cname" {
  count   = var.env == "production" ? 1 : 0
  zone_id = aws_route53_zone.notification-canada-ca[0].zone_id
  name    = "_4e30c74d7459e0d63bdcdaac7a57fdcf.assets.notification.canada.ca"
  type    = "CNAME"
  records = [
    "_2da9b84f7e094fd64c8930cffe8d9842.wggjkglgrm.acm-validations.aws."
  ]
  ttl = "300"
}

resource "aws_route53_record" "assets-notification-canada-ca-cname" {
  count   = var.env == "production" ? 1 : 0
  zone_id = aws_route53_zone.notification-canada-ca[0].zone_id
  name    = "assets.notification.canada.ca"
  type    = "CNAME"
  records = [
    "d1spq0ojswv1dj.cloudfront.net"
  ]
  ttl = "300"
}

resource "aws_route53_record" "notification-canada-ca-SPF" {
  count   = var.env == "production" ? 1 : 0
  zone_id = aws_route53_zone.notification-canada-ca[0].zone_id
  name    = "notification.canada.ca"
  type    = "TXT"
  records = [
    # Used for https://postmaster.google.com
    "google-site-verification=KMFWVel40xicbDXojkXz_1B2gBlPFSqF69cVdH_dfn0",
    "google-site-verification=WNq0Z6naWk2E9SfS9eYq6Y6ZHH29nmkgox3chj5I9iE",
    "v=spf1 include:amazonses.com -all"
  ]
  ttl = "300"
}

resource "aws_route53_record" "notification-canada-ca-DMARC" {
  count   = var.env == "production" ? 1 : 0
  zone_id = aws_route53_zone.notification-canada-ca[0].zone_id
  name    = "_dmarc.notification.canada.ca"
  type    = "TXT"
  records = [
    "v=DMARC1; p=reject; sp=reject; pct=100; rua=mailto:dmarc@cyber.gc.ca"
  ]
  ttl = "300"
}

resource "aws_route53_record" "amazonses-notification-canada-ca-TXT" {
  count   = var.env == "production" ? 1 : 0
  zone_id = aws_route53_zone.notification-canada-ca[0].zone_id
  name    = "_amazonses.notification.canada.ca"
  type    = "TXT"
  records = [
    # ca-central-1
    "Ohfl/Syh3ZT5U/7IKELTCXIRaqI42ZJiw0HiUQoCHww=",
    # us-east-1 for inbound emails
    "FHX+PBM3ip2HfDeSXs3WpEuQZydluvX9VpOdBKj0dgU="
  ]
  ttl = "300"
}

resource "aws_route53_record" "amazonses-mail-from-notification-canada-ca-TXT" {
  count   = var.env == "production" ? 1 : 0
  zone_id = aws_route53_zone.notification-canada-ca[0].zone_id
  name    = "bounce.notification.canada.ca"
  type    = "TXT"
  records = [
    "v=spf1 include:amazonses.com -all"
  ]
  ttl = "300"
}

resource "aws_route53_record" "amazonses-mail-from-notification-canada-ca-MX" {
  count   = var.env == "production" ? 1 : 0
  zone_id = aws_route53_zone.notification-canada-ca[0].zone_id
  name    = "bounce.notification.canada.ca"
  type    = "MX"
  records = [
    "10 feedback-smtp.ca-central-1.amazonses.com"
  ]
  ttl = "300"
}

resource "aws_route53_record" "amazonses-inbound-notification-canada-ca-MX" {
  count   = var.env == "production" ? 1 : 0
  zone_id = aws_route53_zone.notification-canada-ca[0].zone_id
  name    = "notification.canada.ca"
  type    = "MX"
  records = [
    "10 inbound-smtp.us-east-1.amazonaws.com"
  ]
  ttl = "300"
}
