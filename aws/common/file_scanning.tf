module "s3_scan_objects" {
  source = "github.com/cds-snc/terraform-modules//S3_scan_object?ref=v6.1.5"

  s3_upload_bucket_name   = "notification-canada-ca-${var.env}-document-download-scan-files"
  s3_scan_object_role_arn = "arn:aws:iam::${var.scan_files_account_id}:role/s3-scan-object"
  scan_files_role_arn     = "arn:aws:iam::${var.scan_files_account_id}:role/scan-files-api"

  billing_tag_value = var.billing_tag_value
}
