output "acm_cert_name_validation" {
  description = "Certificate verification CNAME for naked domain"
  value       = aws_acm_certificate.notification-canada-ca.domain_validation_options
}

output "aws_acm_notification_canada_ca_arn" {
  description = "Certificate ARN for use in loadbalancer"
  value       = aws_acm_certificate.notification-canada-ca.arn
}

output "aws_acm_alt_notification_canada_ca_arn" {
  description = "Certificate ARN for use in loadbalancer for alt domain"
  value       = var.alt_domain != "" ? aws_acm_certificate.notification-canada-ca-alt.arn : ""
}

output "ses_verification" {
  description = "Verification TXT record for SES"
  value       = aws_ses_domain_identity.notification-canada-ca.verification_token
}

output "dkim_verification_token" {
  description = "DKIM CNAME record for SES"
  value       = aws_ses_domain_dkim.notification-canada-ca.dkim_tokens
}
