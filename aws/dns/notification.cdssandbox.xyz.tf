resource "aws_route53_zone" "notification-sandbox" {
  count = var.env == "production" ? 0 : 1
  name  = "notification.cdssandbox.xyz"
}

resource "aws_route53_record" "notification-sandbox-MX" {
  count    = var.env == "production" ? 0 : 1
  provider = aws.dns
  zone_id  = aws_route53_zone.notification-sandbox
  name     = var.domain
  type     = "MX"
  ttl      = "300"
  records  = ["10 inbound-smtp.us-east-1.amazonaws.com"]
}

resource "aws_route53_record" "bounce-notification-sandbox-MX" {
  count    = var.env == "production" ? 0 : 1
  provider = aws.dns
  zone_id  = aws_route53_zone.notification-sandbox
  name     = "bounce.${var.domain}"
  type     = "MX"
  ttl      = "300"
  records  = ["10 feedback-smtp.ca-central-1.amazonses.com"]
}

resource "aws_route53_record" "bounce-custom-notification-sandbox-MX" {
  count    = var.env == "production" ? 0 : 1
  provider = aws.dns
  zone_id  = aws_route53_zone.notification-sandbox
  name     = "bounce.custom-sending-domain.${var.domain}"
  type     = "MX"
  ttl      = "300"
  records  = ["10 feedback-smtp.ca-central-1.amazonses.com"]
}

resource "aws_route53_record" "ses-notification-sandbox-TXT" {
  count    = var.env == "production" ? 0 : 1
  provider = aws.dns
  zone_id  = aws_route53_zone.notification-sandbox
  name     = "_amazonses.${var.domain}"
  type     = "TXT"
  ttl      = "300"
  records = ["vJFwJM0wnPRWKFXsoiVl9/gLXFP4RL5Xfl4C9JTp3VI=",
    "AwTGEoIByR4QGirawhDmRdJmxFO/U0fX3NMrSOJpuI4="
  ]
}

resource "aws_route53_record" "dmarc-notification-sandbox-TXT" {
  count    = var.env == "production" ? 0 : 1
  provider = aws.dns
  zone_id  = aws_route53_zone.notification-sandbox
  name     = "_dmarc.${var.domain}"
  type     = "TXT"
  ttl      = "300"
  records  = ["v=DMARC1; p=reject; sp=reject; pct=100; rua=mailto:dmarc@cyber.gc.ca; ruf=mailto:dmarc@cyber.gc.ca"]
}

resource "aws_route53_record" "notification-sandbox-TXT" {
  count    = var.env == "production" ? 0 : 1
  provider = aws.dns
  zone_id  = aws_route53_zone.notification-sandbox
  name     = var.domain
  type     = "TXT"
  ttl      = "300"
  records = ["v=spf1 include:amazonses.com ~all",
    "google-site-verification=u0zkO-jbYi1qW2G65mfXbuNl14BCO1O9uk-BV2wTlD8"
  ]
}

resource "aws_route53_record" "bounce-notification-sandbox-TXT" {
  count    = var.env == "production" ? 0 : 1
  provider = aws.dns
  zone_id  = aws_route53_zone.notification-sandbox
  name     = "bounce.${var.domain}"
  type     = "TXT"
  ttl      = "300"
  records  = ["v=spf1 include:amazonses.com ~all"]
}

resource "aws_route53_record" "custom-domain-aws-ses-sandbox-TXT" {
  count    = var.env == "production" ? 0 : 1
  zone_id  = aws_route53_zone.notification-sandbox
  provider = aws.dns
  name     = "_amazonses.custom-sending-domain.${var.domain}"
  type     = "TXT"
  ttl      = "300"
  records  = ["fXT/J45wZcUoBSnJAwPyfnHVf5E2b7aNayCC5PeQltg="]
}

resource "aws_route53_record" "custom-domain-ses-sandbox-TXT" {
  count    = var.env == "production" ? 0 : 1
  provider = aws.dns
  zone_id  = aws_route53_zone.notification-sandbox
  name     = "custom-sending-domain.${var.domain}"
  type     = "TXT"
  ttl      = "300"
  records  = ["amazonses:fXT/J45wZcUoBSnJAwPyfnHVf5E2b7aNayCC5PeQltg="]
}