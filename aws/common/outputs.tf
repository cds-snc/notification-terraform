output "notification_canada_ca_ses_callback_arn" {
  value = aws_sns_topic.notification-canada-ca-ses-callback.arn
}

output "vpc_id" {
  value = aws_vpc.notification-canada-ca.id
}

output "vpc_private_subnets" {
  value = aws_subnet.notification-canada-ca-private.*.id
}

output "vpc_private_subnets_k8s" {
  value = aws_subnet.notification-canada-ca-private-k8s.*.id
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

output "sns_alert_ok_arn" {
  value = aws_sns_topic.notification-canada-ca-alert-ok.arn
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

output "s3_bucket_sms_usage_id" {
  value = module.sns_sms_usage_report_bucket.s3_bucket_id
}

output "s3_bucket_sms_usage_sanitized_ca_central_id" {
  value = module.sns_sms_usage_report_sanitized_bucket.s3_bucket_id
}

output "s3_bucket_sms_usage_sanitized_us_west_id" {
  value = module.sns_sms_usage_report_sanitized_bucket_us_west_2.s3_bucket_id
}

output "firehose_waf_logs_iam_role_arn" {
  value = aws_iam_role.firehose_waf_logs.arn
}

output "ip_blocklist_arn" {
  value = aws_wafv2_ip_set.ip_blocklist.arn
}

output "re_api_arn" {
  value       = aws_wafv2_regex_pattern_set.re_api.arn
  description = "The ARN of the regex pattern set for the allowed URLs of the API"
}

output "re_admin_arn" {
  value       = aws_wafv2_regex_pattern_set.re_admin.arn
  description = "The ARN of the regex pattern set for the allowed URLs of the admin"
}

output "re_admin_arn2" {
  value       = aws_wafv2_regex_pattern_set.re_admin2.arn
  description = "The ARN of the regex pattern set for the allowed URLs of the admin"
}

output "re_document_download_arn" {
  value       = aws_wafv2_regex_pattern_set.re_document_download.arn
  description = "The ARN of the regex pattern set for the allowed URLs of the document download API"
}

output "re_documentation_arn" {
  value       = aws_wafv2_regex_pattern_set.re_documentation.arn
  description = "The ARN of the regex pattern set for the allowed URLs of the documentation website"
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
  value = var.cloudwatch_enabled ? aws_cloudwatch_log_group.sns_deliveries[0].arn : ""
}

output "sns_deliveries_ca_central_name" {
  value = var.cloudwatch_enabled ? aws_cloudwatch_log_group.sns_deliveries[0].name : ""
}

output "sns_deliveries_failures_ca_central_arn" {
  value = var.cloudwatch_enabled ? aws_cloudwatch_log_group.sns_deliveries_failures[0].arn : ""
}

output "sns_deliveries_failures_ca_central_name" {
  value = var.cloudwatch_enabled ? aws_cloudwatch_log_group.sns_deliveries_failures[0].name : ""
}

output "sns_deliveries_us_west_2_arn" {
  value = var.cloudwatch_enabled ? aws_cloudwatch_log_group.sns_deliveries_us_west_2[0].arn : ""
}

output "sns_deliveries_us_west_2_name" {
  value = var.cloudwatch_enabled ? aws_cloudwatch_log_group.sns_deliveries_us_west_2[0].name : ""
}

output "sns_deliveries_failures_us_west_2_arn" {
  value = var.cloudwatch_enabled ? aws_cloudwatch_log_group.sns_deliveries_failures_us_west_2[0].arn : ""
}

output "sns_deliveries_failures_us_west_2_name" {
  value = var.cloudwatch_enabled ? aws_cloudwatch_log_group.sns_deliveries_failures_us_west_2[0].name : ""
}

output "sqs_notify_internal_tasks_arn" {
  value = aws_sqs_queue.notify_internal_tasks_queue.arn
}

output "cbs_satellite_bucket_name" {
  value = var.create_cbs_bucket ? var.cbs_satellite_bucket_name : ""
}

output "sqs_eks_notification_canada_cadelivery_receipts_arn" {
  value = aws_sqs_queue.eks_notification_canada_cadelivery_receipts.arn
}

output "notification_base_url_regex_arn" {
  value       = aws_wafv2_regex_pattern_set.notification_base_url.arn
  description = "The ARN of the regex pattern set for the allowed base domains"
}

output "sqs_send_sms_low_queue_name" {
  value = var.sqs_send_sms_low_queue_name
}

output "sqs_send_sms_medium_queue_name" {
  value = var.sqs_send_sms_medium_queue_name
}

output "sqs_send_sms_high_queue_name" {
  value = var.sqs_send_sms_high_queue_name
}

output "sqs_send_email_low_queue_name" {
  value = var.sqs_send_email_low_queue_name
}

output "sqs_send_email_medium_queue_name" {
  value = var.sqs_send_email_medium_queue_name
}

output "sqs_send_email_high_queue_name" {
  value = var.sqs_send_email_high_queue_name
}

output "sqs_deliver_receipts_queue_arn" {
  value = aws_sqs_queue.eks_notification_canada_cadelivery_receipts.arn
}

output "subnet_ids" {
  value = aws_subnet.notification-canada-ca-private[*].id
}

output "subnet_cidr_blocks" {
  value = aws_subnet.notification-canada-ca-private[*].cidr_block
}

output "sns_monthly_spend_limit" {
  value = var.sns_monthly_spend_limit
}

output "celery_queue_prefix" {
  value = var.celery_queue_prefix
}

output "sqs_send_sms_high_queue_delay_warning_arn" {
  value = var.cloudwatch_enabled ? aws_cloudwatch_metric_alarm.sqs-send-sms-high-queue-delay-warning[0].arn : ""
}

output "sqs_send_sms_high_queue_delay_critical_arn" {
  value = var.cloudwatch_enabled ? aws_cloudwatch_metric_alarm.sqs-send-sms-high-queue-delay-critical[0].arn : ""
}

output "sqs_send_sms_medium_queue_delay_warning_arn" {
  value = var.cloudwatch_enabled ? aws_cloudwatch_metric_alarm.sqs-send-sms-medium-queue-delay-warning[0].arn : ""
}

output "sqs_send_sms_medium_queue_delay_critical_arn" {
  value = var.cloudwatch_enabled ? aws_cloudwatch_metric_alarm.sqs-send-sms-medium-queue-delay-critical[0].arn : ""
}

output "sqs_send_sms_low_queue_delay_warning_arn" {
  value = var.cloudwatch_enabled ? aws_cloudwatch_metric_alarm.sqs-send-sms-low-queue-delay-warning[0].arn : ""
}

output "sqs_send_sms_low_queue_delay_critical_arn" {
  value = var.cloudwatch_enabled ? aws_cloudwatch_metric_alarm.sqs-send-sms-low-queue-delay-critical[0].arn : ""
}
