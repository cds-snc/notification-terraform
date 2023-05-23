resource "aws_route53_record" "ses_custom_domain_dkim_record" {
  for_each        = { for cd in jsondecode(var.custom_sending_domains_dkim) : "${cd.domain}.${cd.token}" => cd }
  provider        = aws.staging
  zone_id         = var.route53_zone_arn
  name            = "${each.value.token}._domainkey.${each.value.domain}"
  type            = "CNAME"
  ttl             = "600"
  allow_overwrite = true
  records         = ["${each.value.token}.dkim.amazonses.com"]
}


resource "aws_route53_record" "notification_canada_ca_dkim_record" {
  for_each        = { for s in jsondecode(var.notification_canada_ca_dkim) : "${s}" => s }
  provider        = aws.staging
  zone_id         = var.route53_zone_arn
  name            = "${each.value}._domainkey.${var.domain}"
  type            = "CNAME"
  ttl             = "600"
  allow_overwrite = true
  records         = ["${each.value}.dkim.amazonses.com"]
}


resource "aws_route53_record" "ses_cic_trvapply_vrtdemande_dkim_record" {
  for_each        = { for cd in jsondecode(var.cic_trvapply_vrtdemande_dkim) : "${cd.domain}.${cd.token}" => cd }
  provider        = aws.staging
  zone_id         = var.route53_zone_arn
  name            = "${each.value.token}._domainkey.${each.value.domain}"
  type            = "CNAME"
  ttl             = "600"
  allow_overwrite = true
  records         = ["${each.value.token}.dkim.amazonses.com"]
}
