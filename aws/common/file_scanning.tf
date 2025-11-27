module "s3_scan_objects" {
  source = "github.com/cds-snc/terraform-modules//S3_scan_object?ref=v10.9.1"

  s3_upload_bucket_names  = ["notification-canada-ca-${var.env}-document-download-scan-files"]
  s3_scan_object_role_arn = "arn:aws:iam::${var.scan_files_account_id}:role/s3-scan-object"
  scan_files_role_arn     = "arn:aws:iam::${var.scan_files_account_id}:role/scan-files-api"

  billing_tag_value = var.billing_tag_value
}

module "guardduty_malware_s3" {
  count = var.env == "staging" ? 1 : 0

  source = "github.com/cds-snc/terraform-modules//guardduty_malware_s3?ref=v10.9.1"

  s3_bucket_name = "notification-canada-ca-${var.env}-document-download-scan-files"
  tagging_status = "ENABLED"

  alarms_enabled                           = true
  alarm_completed_scan_count_threshold     = 20000
  alarm_completed_scan_gigabytes_threshold = 2
  alarm_sns_topic_alarm_arn                = aws_sns_topic.notification-canada-ca-alert-warning.arn
  alarm_sns_topic_ok_arn                   = aws_sns_topic.notification-canada-ca-alert-ok.arn

  billing_tag_value = var.billing_tag_value
}

// Support introduction of feature flag for module
// This is required as the scanning service S3 object tags overwrite each other's existing tags
moved {
  from = module.guardduty_malware_s3.aws_cloudwatch_metric_alarm.malware_completed_scan_bytes
  to   = module.guardduty_malware_s3[0].aws_cloudwatch_metric_alarm.malware_completed_scan_bytes
}

moved {
  from = module.guardduty_malware_s3.aws_cloudwatch_metric_alarm.malware_completed_scan_count
  to   = module.guardduty_malware_s3[0].aws_cloudwatch_metric_alarm.malware_completed_scan_count
}

moved {
  from = module.guardduty_malware_s3.aws_guardduty_malware_protection_plan.this
  to   = module.guardduty_malware_s3[0].aws_guardduty_malware_protection_plan.this
}

moved {
  from = module.guardduty_malware_s3.aws_iam_policy.this
  to   = module.guardduty_malware_s3[0].aws_iam_policy.this
}

moved {
  from = module.guardduty_malware_s3.aws_iam_role.this
  to   = module.guardduty_malware_s3[0].aws_iam_role.this
}

moved {
  from = module.guardduty_malware_s3.aws_iam_role_policy_attachment.this
  to   = module.guardduty_malware_s3[0].aws_iam_role_policy_attachment.this
}
