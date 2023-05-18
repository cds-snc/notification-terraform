output "ses_verification" {
  description = "Verification TXT record for SES"
  value       = aws_ses_domain_identity.notification-canada-ca.verification_token
}

output "dkim_verification_token" {
  description = "DKIM CNAME record for SES"
  value       = aws_ses_domain_dkim.notification-canada-ca.dkim_tokens
}

output "route_53_zone_arn" {
  value = var.env == "staging" ? aws_route53_zone.notification-sandbox[0].zone_id : null
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

