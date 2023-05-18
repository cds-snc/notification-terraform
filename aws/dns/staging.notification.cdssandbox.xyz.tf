
resource "aws_route53_record" "staging-notification-sandbox-MX" {
  count   = var.env == "staging" ? 1 : 0
  zone_id = aws_route53_zone.notification-sandbox[0].zone_id
  name    = "staging.notification.cdssandbox.xyz"
  type    = "MX"
  ttl     = "300"
  records = ["10 inbound-smtp.us-east-1.amazonaws.com"]
}

resource "aws_route53_record" "staging-notification-sandbox-TXT" {
  count   = var.env == "staging" ? 1 : 0
  zone_id = aws_route53_zone.notification-sandbox[0].zone_id
  name    = "staging.notification.cdssandbox.xyz"
  type    = "TXT"
  ttl     = "300"
  records = ["v=spf1 include:amazonses.com ~all",
    "google-site-verification=u0zkO-jbYi1qW2G65mfXbuNl14BCO1O9uk-BV2wTlD8"
  ]
}

resource "aws_route53_record" "ses-staging-notification-sandbox-TXT" {
  count   = var.env == "staging" ? 1 : 0
  zone_id = aws_route53_zone.notification-sandbox[0].zone_id
  name    = "_amazonses.staging.notification.cdssandbox.xyz"
  type    = "TXT"
  ttl     = "300"
  records = ["vJFwJM0wnPRWKFXsoiVl9/gLXFP4RL5Xfl4C9JTp3VI=",
    "AwTGEoIByR4QGirawhDmRdJmxFO/U0fX3NMrSOJpuI4="
  ]
}

resource "aws_route53_record" "dmarc-staging-notification-sandbox-TXT" {
  count   = var.env == "staging" ? 1 : 0
  zone_id = aws_route53_zone.notification-sandbox[0].zone_id
  name    = "_dmarc.staging.notification.cdssandbox.xyz"
  type    = "TXT"
  ttl     = "300"
  records = ["v=DMARC1; p=reject; sp=reject; pct=100; rua=mailto:dmarc@cyber.gc.ca; ruf=mailto:dmarc@cyber.gc.ca"]
}

resource "aws_route53_record" "assets-staging-notification-sandbox-CNAME" {
  count   = var.env == "staging" ? 1 : 0
  zone_id = aws_route53_zone.notification-sandbox[0].zone_id
  name    = "assets.staging.notification.cdssandbox.xyz"
  type    = "CNAME"
  ttl     = "300"
  records = ["d3ukkp8cndubgn.cloudfront.net"]
}

resource "aws_route53_record" "bounce-staging-notification-sandbox-MX" {
  count   = var.env == "staging" ? 1 : 0
  zone_id = aws_route53_zone.notification-sandbox[0].zone_id
  name    = "bounce.staging.notification.cdssandbox.xyz"
  type    = "MX"
  ttl     = "300"
  records = ["10 feedback-smtp.ca-central-1.amazonses.com"]
}

resource "aws_route53_record" "bounce-staging-custom-notification-sandbox-MX" {
  count   = var.env == "staging" ? 1 : 0
  zone_id = aws_route53_zone.notification-sandbox[0].zone_id
  name    = "bounce.custom-sending-domain.staging.notification.cdssandbox.xyz"
  type    = "MX"
  ttl     = "300"
  records = ["10 feedback-smtp.ca-central-1.amazonses.com"]
}

resource "aws_route53_record" "bounce-staging-notification-sandbox-TXT" {
  count   = var.env == "staging" ? 1 : 0
  zone_id = aws_route53_zone.notification-sandbox[0].zone_id
  name    = "bounce.staging.notification.cdssandbox.xyz"
  type    = "TXT"
  ttl     = "300"
  records = ["v=spf1 include:amazonses.com ~all"]
}