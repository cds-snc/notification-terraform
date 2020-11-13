output "acm_cert_name_validation" {
  description = "Certificate verification CNAME for naked domain"
  value       = aws_acm_certificate.notification-canada-ca.domain_validation_options
}

output "ses_verification" {
  description = "Verification TXT record for SES"
  value       = aws_ses_domain_identity.notification-canada-ca.verification_token
}

output "dkim_verification_token" {
  description = "DKIM CNAME record for SES"
  value       = aws_ses_domain_dkim.notification-canada-ca.dkim_tokens
}