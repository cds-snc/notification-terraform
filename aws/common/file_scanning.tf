module "s3_scan_objects" {
  source = "github.com/cds-snc/terraform-modules?ref=v3.0.9//S3_scan_object"

  product_name          = "gc-notify"
  s3_upload_bucket_name = "notification-canada-ca-${var.env}-document-download"

  billing_tag_value = var.billing_tag_value
}
