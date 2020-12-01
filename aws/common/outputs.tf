output "notification_canada_ca_ses_callback_arn" {
  value = aws_sns_topic.notification-canada-ca-ses-callback.arn
}

output "vpc_id" {
  value = aws_vpc.notification-canada-ca.id
}

output "vpc_private_subnets" {
  value = aws_subnet.notification-canada-ca-private.*.id
}

output "vpc_public_subnets" {
  value = aws_subnet.notification-canada-ca-public.*.id
}

output "sns_alert_warning_arn" {
  value = aws_sns_topic.notification-canada-ca-alert-warning.arn
}

output "sns_alert_critical_arn" {
  value = aws_sns_topic.notification-canada-ca-alert-critical.arn
}

output "asset_bucket_regional_domain_name" {
  value = aws_s3_bucket.asset_bucket.bucket_regional_domain_name
}

output "alb_log_bucket" {
  value = aws_s3_bucket.alb_log_bucket.bucket
}
