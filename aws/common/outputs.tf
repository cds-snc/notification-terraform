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

output "sns_alert_general_arn" {
  value = aws_sns_topic.notification-canada-ca-alert-general.arn
}

output "asset_bucket_regional_domain_name" {
  value = aws_s3_bucket.asset_bucket.bucket_regional_domain_name
}

output "alb_log_bucket" {
  value = aws_s3_bucket.alb_log_bucket.bucket
}

output "kms_arn" {
  value = aws_kms_key.notification-canada-ca.arn
}

output "lambda_ses_receiving_emails_arn" {
  value = aws_lambda_function.ses_receiving_emails.arn
}

output "s3_bucket_asset_bucket_id" {
  value = aws_s3_bucket.asset_bucket.id
}

output "s3_bucket_asset_bucket_arn" {
  value = aws_s3_bucket.asset_bucket.arn
}

output "s3_bucket_csv_upload_bucket_arn" {
  value = aws_s3_bucket.csv_bucket.arn
}

output "firehose_waf_logs_iam_role_arn" {
  value = aws_iam_role.firehose_waf_logs.arn
}
