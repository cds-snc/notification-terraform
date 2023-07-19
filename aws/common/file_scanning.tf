module "s3_scan_objects" {
  source = "github.com/cds-snc/terraform-modules//S3_scan_object?ref=v6.0.1"

  s3_upload_bucket_name = aws_s3_bucket.scan_files_document_bucket.id
  billing_tag_value     = var.billing_tag_value
}
