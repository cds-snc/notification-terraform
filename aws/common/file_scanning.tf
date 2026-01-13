module "guardduty_malware_s3" {
  count = var.enable_guardduty_malware_s3 ? 1 : 0

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

/*
 * Prevent the destruction of S3 bucket notifications when the `S3_scan_object` module
 * is removed.  This ensures that the GuardDuty Malware S3 EventBridge notifications
 * continue to be sent.
 */
removed {
  from = module.s3_scan_objects[0].aws_s3_bucket_notification.s3_scan_object[0]
  lifecycle {
    destroy = false
  }
}