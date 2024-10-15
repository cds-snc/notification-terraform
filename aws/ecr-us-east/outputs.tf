output "ses_receiving_emails_ecr_arn" {
  description = "arn of ses_receiving_emails ECR"
  value       = aws_ecr_repository.ses_receiving_emails.arn
}
output "ses_receiving_emails_ecr_repository_url" {
  description = "Repository URL of ses_receiving_emails ECR"
  value       = aws_ecr_repository.ses_receiving_emails.repository_url
}