output "pinpoint_to_sqs_sms_callbacks_ecr_arn" {
  description = "ARN of the pinpoint_to_sqs_sms_callbacks ECR repository in us-west-2"
  value       = aws_ecr_repository.pinpoint_to_sqs_sms_callbacks.arn
}

output "pinpoint_to_sqs_sms_callbacks_ecr_repository_url" {
  description = "Repository URL of the pinpoint_to_sqs_sms_callbacks ECR repository in us-west-2"
  value       = aws_ecr_repository.pinpoint_to_sqs_sms_callbacks.repository_url
}
