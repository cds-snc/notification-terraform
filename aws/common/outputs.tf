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

output "kms_arn" {
  value = aws_kms_key.notification-canada-ca.arn
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

output "ip_blocklist_arn" {
  value = aws_wafv2_ip_set.ip_blocklist.arn
}

output "private-links-vpc-endpoints-securitygroup" {
  value       = aws_security_group.vpc_endpoints.id
  description = "private links vpc endpoint security group id"
}

output "private-links-gateway-prefix-list-ids" {
  value = [
    for gateway in aws_vpc_endpoint.gateway : gateway.prefix_list_id
  ]
  description = "The prefix list IDs for the gateway private links"
}

output "sns_alert_warning_arn_us_east_1" {
  value = aws_sns_topic.notification-canada-ca-alert-warning-us-east-1.arn
}

output "sns_alert_critical_arn_us_east_1" {
  value = aws_sns_topic.notification-canada-ca-alert-critical-us-east-1.arn
}

output "sns_alert_ok_arn_us_east_1" {
  value = aws_sns_topic.notification-canada-ca-alert-ok-us-east-1.arn
}

output "sns_deliveries_ca_central_arn" {
  value = aws_cloudwatch_log_group.sns_deliveries.arn
}

output "sns_deliveries_ca_central_name" {
  value = aws_cloudwatch_log_group.sns_deliveries.name
}

output "sns_deliveries_failures_ca_central_arn" {
  value = aws_cloudwatch_log_group.sns_deliveries_failures.arn
}

output "sns_deliveries_failures_ca_central_name" {
  value = aws_cloudwatch_log_group.sns_deliveries_failures.name
}

output "sns_deliveries_us_west_2_arn" {
  value = aws_cloudwatch_log_group.sns_deliveries_us_west_2.arn
}

output "sns_deliveries_us_west_2_name" {
  value = aws_cloudwatch_log_group.sns_deliveries_us_west_2.name
}

output "sns_deliveries_failures_us_west_2_arn" {
  value = aws_cloudwatch_log_group.sns_deliveries_failures_us_west_2.arn
}

output "sns_deliveries_failures_us_west_2_name" {
  value = aws_cloudwatch_log_group.sns_deliveries_failures_us_west_2.name
}
