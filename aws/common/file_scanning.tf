module "s3_scan_objects" {
  source = "github.com/cds-snc/terraform-modules?ref=v5.1.11//S3_scan_object"

  product_name          = "gc-notify"
  s3_upload_bucket_name = "notification-canada-ca-${var.env}-document-download-scan-files"
  log_level             = "DEBUG"

  billing_tag_value = var.billing_tag_value
}
