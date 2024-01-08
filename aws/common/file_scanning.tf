locals {
  scan_files_account = var.env == "production" ? "806545929748" : "127893201980"
}

module "s3_scan_objects" {
  source = "github.com/cds-snc/terraform-modules//S3_scan_object?ref=v6.0.1"

  s3_upload_bucket_name   = "notification-canada-ca-${var.env}-document-download-scan-files"
  s3_scan_object_role_arn = "arn:aws:iam::${local.scan_files_account}:role/s3-scan-object"
  scan_files_role_arn     = "arn:aws:iam::${local.scan_files_account}:role/scan-files-api"

  billing_tag_value = var.billing_tag_value
}
