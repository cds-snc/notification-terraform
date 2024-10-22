output "dkim_verification_token" {
  description = "DKIM CNAME record for SES"
  value       = aws_ses_domain_dkim.notification-canada-ca.dkim_tokens
}

output "custom_sending_domains_dkim" {
  value = local.custom_sending_domain_dkim_records
}

output "cic_trvapply_vrtdemande_dkim" {
  value = local.ses_cic_trvapply_vrtdemande_dkim_records
}

output "notification_canada_ca_dkim" {
  value = aws_ses_domain_dkim.notification-canada-ca.dkim_tokens

}

output "notification_canada_ca_receiving_dkim" {
  value = aws_ses_domain_dkim.notification-canada-ca-receiving.dkim_tokens
}
output "notification_internal_dns_cert" {
  value = base64encode(tls_self_signed_cert.internal_dns.cert_pem)
}

output "notification_internal_dns_key" {
  value     = base64encode(tls_private_key.internal_dns.private_key_pem)
  sensitive = true
}

output "internal_dns_certificate_arn" {
  value = aws_acm_certificate.internal_dns.arn
}

output "internal_dns_zone_id" {
  value = aws_route53_zone.internal_dns.zone_id
}

output "internal_dns_name" {
  value = aws_route53_zone.internal_dns.name
}

output "route53_zone_id" {
  value = var.env == "production" ? aws_route53_zone.notification-canada-ca[0].zone_id : var.env == "staging" ? aws_route53_zone.notification-sandbox[0].zone_id : var.hosted_zone_id
}