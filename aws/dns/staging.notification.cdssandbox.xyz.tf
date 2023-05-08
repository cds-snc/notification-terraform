resource "aws_route53_record" "staging-notification-sandbox" {
  count   = var.env == "staging" ? 1 : 0
  zone_id = aws_route53_zone.notification-sandbox[0].zone_id
  name    = "staging.notification.cdssandbox.xyz"
  type    = "A"

  alias {
    name                   = "dualstack.notification-staging-alb-1878361959.ca-central-1.elb.amazonaws.com"
    zone_id                = "ZQSVJUPU6J1EY"
    evaluate_target_health = false
  }

}

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

resource "aws_route53_record" "staging-notification-sandbox-WC" {
  count   = var.env == "staging" ? 1 : 0
  name    = "*.staging.notification.cdssandbox.xyz"
  zone_id = aws_route53_zone.notification-sandbox[0].zone_id
  type    = "A"

  alias {
    name                   = "dualstack.notification-staging-alb-1878361959.ca-central-1.elb.amazonaws.com"
    zone_id                = "ZQSVJUPU6J1EY"
    evaluate_target_health = false
  }

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

resource "aws_route53_record" "api-k8s-staging-notification-sandbox-CNAME" {
  count   = var.env == "staging" ? 1 : 0
  zone_id = aws_route53_zone.notification-sandbox[0].zone_id
  name    = "api-k8s.staging.notification.cdssandbox.xyz"
  type    = "CNAME"
  ttl     = "60"
  records = ["notification-staging-alb-1878361959.ca-central-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "api-lambda-staging-notification-sandbox-A" {
  count   = var.env == "staging" ? 1 : 0
  zone_id = aws_route53_zone.notification-sandbox[0].zone_id
  name    = "api-lambda.staging.notification.cdssandbox.xyz"
  type    = "A"

  alias {
    name                   = "d-087bebwcdc.execute-api.ca-central-1.amazonaws.com."
    zone_id                = "Z19DQILCV0OWEC"
    evaluate_target_health = false
  }

}

resource "aws_route53_record" "api-weighted-100-staging-notification-sandbox-A" {
  # Send all API traffic to Lambda
  count          = var.env == "staging" ? 1 : 0
  zone_id        = aws_route53_zone.notification-sandbox[0].zone_id
  name           = "api.staging.notification.cdssandbox.xyz"
  type           = "A"
  set_identifier = "lambda"

  alias {
    name                   = "d-cmqtfgeja3.execute-api.ca-central-1.amazonaws.com"
    zone_id                = "Z19DQILCV0OWEC"
    evaluate_target_health = false
  }

  weighted_routing_policy {
    weight = 100
  }
}

resource "aws_route53_record" "api-weighted-0-staging-notification-sandbox-A" {
  # Send no API traffic to K8s
  count          = var.env == "staging" ? 1 : 0
  zone_id        = aws_route53_zone.notification-sandbox[0].zone_id
  name           = "api.staging.notification.cdssandbox.xyz"
  type           = "A"
  set_identifier = "loadbalancer"

  alias {
    name                   = "notification-staging-alb-1878361959.ca-central-1.elb.amazonaws.com"
    zone_id                = "ZQSVJUPU6J1EY"
    evaluate_target_health = false
  }

  weighted_routing_policy {
    weight = 0
  }
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

resource "aws_route53_record" "bounce-staging-notification-sandbox-TXT" {
  count   = var.env == "staging" ? 1 : 0
  zone_id = aws_route53_zone.notification-sandbox[0].zone_id
  name    = "bounce.staging.notification.cdssandbox.xyz"
  type    = "TXT"
  ttl     = "300"
  records = ["v=spf1 include:amazonses.com ~all"]
}