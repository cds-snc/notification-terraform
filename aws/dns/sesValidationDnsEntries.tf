locals {
  custom_sending_domain_dkim_records = distinct(flatten([
    for cd in aws_ses_domain_dkim.custom_sending_domains : [
      for token in cd.dkim_tokens : {
        domain = cd.domain
        token  = token
      }
    ]
  ]))

  ses_cic_trvapply_vrtdemande_dkim_records = distinct(flatten([
    for cd in aws_ses_domain_dkim.cic-trvapply-vrtdemande : [
      for token in cd.dkim_tokens : {
        domain = cd.domain
        token  = token
      }
    ]
  ]))
}


resource "aws_route53_record" "ses_domain_dkim_record" {
  count   = var.env == "production" ? 0 : 3
  zone_id = aws_route53_zone.notification-sandbox[0].zone_id
  name    = "${aws_ses_domain_dkim.notification-canada-ca.dkim_tokens[count.index]}._domainkey"
  type    = "CNAME"
  ttl     = "600"
  records = ["${aws_ses_domain_dkim.notification-canada-ca.dkim_tokens[count.index]}.dkim.amazonses.com"]
}

resource "aws_route53_record" "ses_custom_domain_dkim_record" {
  for_each = { for cd in local.custom_sending_domain_dkim_records : "${cd.domain}.${cd.token}" => cd }
  zone_id  = aws_route53_zone.notification-sandbox[0].zone_id
  name     = "${each.value.domain}._domainkey"
  type     = "CNAME"
  ttl      = "600"
  records  = ["${each.value.token}.dkim.amazonses.com"]
}

resource "aws_route53_record" "ses_cic_trvapply_vrtdemande_dkim_record" {
  for_each = { for cd in local.ses_cic_trvapply_vrtdemande_dkim_records : "${cd.domain}.${cd.token}" => cd }
  zone_id  = aws_route53_zone.notification-sandbox[0].zone_id
  name     = "${each.value.domain}._domainkey"
  type     = "CNAME"
  ttl      = "600"
  records  = ["${each.value.token}.dkim.amazonses.com"]
}