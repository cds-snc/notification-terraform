resource "aws_route53_record" "ses_custom_domain_dkim_record" {
  for_each        = { for cd in jsondecode(var.custom_sending_domains_dkim) : "${cd.domain}.${cd.token}" => cd }
  provider        = aws.dns
  zone_id         = var.route53_zone_id
  name            = "${each.value.token}._domainkey.${each.value.domain}"
  type            = "CNAME"
  ttl             = "600"
  allow_overwrite = true
  records         = ["${each.value.token}.dkim.amazonses.com"]
}


resource "aws_route53_record" "notification_canada_ca_dkim_record" {
  for_each        = { for s in jsondecode(var.notification_canada_ca_dkim) : "${s}" => s }
  provider        = aws.dns
  zone_id         = var.route53_zone_id
  name            = "${each.value}._domainkey.${var.domain}"
  type            = "CNAME"
  ttl             = "300"
  allow_overwrite = true
  records         = ["${each.value}.dkim.amazonses.com"]
}

resource "aws_route53_record" "notification_canada_ca_receiving_dkim_record" {
  for_each        = { for s in jsondecode(var.notification_canada_ca_receiving_dkim) : "${s}" => s }
  provider        = aws.dns
  zone_id         = var.route53_zone_id
  name            = "${each.value}._domainkey.${var.domain}"
  type            = "CNAME"
  ttl             = "300"
  allow_overwrite = true
  records         = ["${each.value}.dkim.amazonses.com"]
}
