resource "aws_route53_zone" "notification-sandbox" {
  count = var.env == "production" ? 0 : 1
  name  = "notification.cdssandbox.xyz"
}

resource "aws_route53_record" "notification-sandbox-MX" {
  count    = var.env == "production" ? 0 : 1
  provider = aws.dns
  zone_id  = var.route_53_zone_arn
  name     = var.domain
  type     = "MX"
  ttl      = "300"
  records  = ["10 inbound-smtp.us-east-1.amazonaws.com"]
}

resource "aws_route53_record" "bounce-notification-sandbox-MX" {
  count    = var.env == "production" ? 0 : 1
  provider = aws.dns
  zone_id  = var.route_53_zone_arn
  name     = "bounce.${var.domain}"
  type     = "MX"
  ttl      = "300"
  records  = ["10 feedback-smtp.ca-central-1.amazonses.com"]
}

resource "aws_route53_record" "bounce-custom-notification-sandbox-MX" {
  count    = var.env == "production" ? 0 : 1
  provider = aws.dns
  zone_id  = var.route_53_zone_arn
  name     = "bounce.custom-sending-domain.${var.domain}"
  type     = "MX"
  ttl      = "300"
  records  = ["10 feedback-smtp.ca-central-1.amazonses.com"]
}

# SES TXT Record - To Be Automated

resource "aws_route53_record" "ses-notification-sandbox-TXT" {
  count    = var.env == "production" ? 0 : 1
  provider = aws.dns
  zone_id  = var.route_53_zone_arn
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
  zone_id  = var.route_53_zone_arn
  name     = "_dmarc.${var.domain}"
  type     = "TXT"
  ttl      = "300"
  records  = ["v=DMARC1; p=reject; sp=reject; pct=100; rua=mailto:dmarc@cyber.gc.ca; ruf=mailto:dmarc@cyber.gc.ca"]
}

# Google Site Verification

resource "aws_route53_record" "notification-sandbox-TXT" {
  count    = var.env == "production" ? 0 : 1
  provider = aws.dns
  zone_id  = var.route_53_zone_arn
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
  zone_id  = var.route_53_zone_arn
  name     = "bounce.${var.domain}"
  type     = "TXT"
  ttl      = "300"
  records  = ["v=spf1 include:amazonses.com ~all"]
}

