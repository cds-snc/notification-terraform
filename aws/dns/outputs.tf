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