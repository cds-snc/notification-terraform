module "s3_scan_objects" {
  count = var.env == "staging" ? 0 : 1

  source = "github.com/cds-snc/terraform-modules//S3_scan_object?ref=v10.9.1"

  s3_upload_bucket_names  = ["notification-canada-ca-${var.env}-document-download-scan-files"]
  s3_scan_object_role_arn = "arn:aws:iam::${var.scan_files_account_id}:role/s3-scan-object"
  scan_files_role_arn     = "arn:aws:iam::${var.scan_files_account_id}:role/scan-files-api"

  billing_tag_value = var.billing_tag_value
}

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

moved {
  from = module.s3_scan_objects.aws_iam_policy.scan_files[0]
  to   = module.s3_scan_objects[0].aws_iam_policy.scan_files[0]
}

moved {
  from = module.s3_scan_objects.aws_iam_role.scan_files[0]
  to   = module.s3_scan_objects[0].aws_iam_role.scan_files[0]
}

moved {
  from = module.s3_scan_objects.aws_iam_role_policy_attachment.scan_files[0]
  to   = module.s3_scan_objects[0].aws_iam_role_policy_attachment.scan_files[0]
}

moved {
  from = module.s3_scan_objects.aws_kms_alias.s3_scan_object_queue
  to   = module.s3_scan_objects[0].aws_kms_alias.s3_scan_object_queue
}

moved {
  from = module.s3_scan_objects.aws_kms_key.s3_scan_object_queue
  to   = module.s3_scan_objects[0].aws_kms_key.s3_scan_object_queue
}

moved {
  from = module.s3_scan_objects.aws_s3_bucket_notification.s3_scan_object[0]
  to   = module.s3_scan_objects[0].aws_s3_bucket_notification.s3_scan_object[0]
}

moved {
  from = module.s3_scan_objects.aws_s3_bucket_policy.upload_bucket[0]
  to   = module.s3_scan_objects[0].aws_s3_bucket_policy.upload_bucket[0]
}

moved {
  from = module.s3_scan_objects.aws_sqs_queue.s3_scan_object
  to   = module.s3_scan_objects[0].aws_sqs_queue.s3_scan_object
}

moved {
  from = module.s3_scan_objects.aws_sqs_queue_policy.s3_scan_object
  to   = module.s3_scan_objects[0].aws_sqs_queue_policy.s3_scan_object
}
