module "s3_scan_objects" {
  source = "github.com/cds-snc/terraform-modules//S3_scan_object?ref=v10.8.3"

  s3_upload_bucket_name   = "notification-canada-ca-${var.env}-document-download-scan-files"
  s3_scan_object_role_arn = "arn:aws:iam::${var.scan_files_account_id}:role/s3-scan-object"
  scan_files_role_arn     = "arn:aws:iam::${var.scan_files_account_id}:role/scan-files-api"

  billing_tag_value = var.billing_tag_value
}

module "guardduty_malware_s3" {
  source = "github.com/cds-snc/terraform-modules//guardduty_malware_s3?ref=v10.8.3"

  s3_bucket_name = "notification-canada-ca-${var.env}-document-download-scan-files"
  tagging_status = "ENABLED"

  alarms_enabled                           = true
  alarm_completed_scan_count_threshold     = 20000
  alarm_completed_scan_gigabytes_threshold = 2
  alarm_sns_topic_alarm_arn                = aws_sns_topic.notification-canada-ca-alert-warning.arn
  alarm_sns_topic_ok_arn                   = aws_sns_topic.notification-canada-ca-alert-ok.arn

  billing_tag_value = var.billing_tag_value
}
