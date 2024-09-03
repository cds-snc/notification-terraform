output "ses_receiving_emails_ecr_arn" {
  description = "arn of ses_receiving_emails ECR"
  value       = aws_ecr_repository.ses_receiving_emails.arn
}
output "ses_receiving_emails_ecr_repository_url" {
  description = "Repository URL of ses_receiving_emails ECR"
  value       = aws_ecr_repository.ses_receiving_emails.repository_url
}
output "ses_to_sqs_email_callbacks_ecr_arn" {
  description = "arn of ses_to_sqs_email_callbacks ECR"
  value       = aws_ecr_repository.ses_to_sqs_email_callbacks.arn
}
output "ses_to_sqs_email_callbacks_ecr_repository_url" {
  description = "Repository URL of ses_to_sqs_email_callbacks ECR"
  value       = aws_ecr_repository.ses_to_sqs_email_callbacks.repository_url
}
output "sns_to_sqs_sms_callbacks_ecr_arn" {
  description = "arn of sns_to_sqs_sms_callbacks ECR"
  value       = aws_ecr_repository.sns_to_sqs_sms_callbacks.arn
}
output "sns_to_sqs_sms_callbacks_ecr_repository_url" {
  description = "Repository URL of sns_to_sqs_sms_callbacks ECR"
  value       = aws_ecr_repository.sns_to_sqs_sms_callbacks.repository_url
}

output "pinpoint_to_sqs_sms_callbacks_ecr_arn" {
  description = "arn of pinpoint_to_sqs_sms_callbacks ECR"
  value       = aws_ecr_repository.pinpoint_to_sqs_sms_callbacks.arn
}
output "pinpoint_to_sqs_sms_callbacks_ecr_repository_url" {
  description = "Repository URL of pinpoint_to_sqs_sms_callbacks ECR"
  value       = aws_ecr_repository.pinpoint_to_sqs_sms_callbacks.repository_url
}

output "heartbeat_ecr_arn" {
  description = "arn of heartbeat ECR"
  value       = aws_ecr_repository.heartbeat.arn
}
output "heartbeat_ecr_repository_url" {
  description = "Repository URL of heartbeat ECR"
  value       = aws_ecr_repository.heartbeat.repository_url
}
output "notify_admin_ecr_arn" {
  description = "arn of notify_admin ECR"
  value       = var.env == "production" ? "" : aws_ecr_repository.notify_admin[0].arn
}
output "notify_admin_ecr_repository_url" {
  description = "Repository URL of notify_admin ECR"
  value       = var.env == "production" ? "" : aws_ecr_repository.notify_admin[0].repository_url
}
output "api_lambda_ecr_arn" {
  description = "arn of api_lambda ECR"
  value       = aws_ecr_repository.api-lambda.arn
}
output "api_lambda_ecr_repository_url" {
  description = "Repository URL of api_lambda ECR"
  value       = aws_ecr_repository.api-lambda.repository_url
}
output "google_cidr_ecr_arn" {
  description = "arn of google-cidr ECR"
  value       = aws_ecr_repository.google-cidr.arn
}
output "google_cidr_ecr_repository_url" {
  description = "Repository URL of google-cidr ECR"
  value       = aws_ecr_repository.google-cidr.repository_url
}
output "performance_test_ecr_arn" {
  description = "arn of performance-test ECR"
  value       = var.env == "production" ? "" : aws_ecr_repository.performance-test[0].arn
}
output "performance_test_ecr_repository_url" {
  description = "Repository URL of performance-test ECR"
  value       = var.env == "production" ? "" : aws_ecr_repository.performance-test[0].repository_url
}
output "system_status_ecr_arn" {
  description = "arn of system_status ECR"
  value       = aws_ecr_repository.system_status.arn
}
output "system_status_ecr_repository_url" {
  description = "Repository URL of system_status ECR"
  value       = aws_ecr_repository.system_status.repository_url
}