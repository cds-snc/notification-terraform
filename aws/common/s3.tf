###
# AWS S3 Buckets for Notification application
###

resource "aws_s3_bucket" "csv_bucket" {
  bucket = "notification-canada-ca-${var.env}-csv-upload"
  acl    = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "expire"
    enabled = true

    expiration {
      days = 30
    }
  }

  logging {
    target_bucket = aws_s3_bucket.csv_bucket_logs.bucket
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_s3_bucket_public_access_block" "csv_bucket" {
  bucket = aws_s3_bucket.csv_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "csv_bucket_logs" {
  bucket = "notification-canada-ca-${var.env}-csv-upload-logs"
  acl    = "log-delivery-write"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    enabled = true

    expiration {
      days = 90
    }
  }
  
  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }

  #tfsec:ignore:AWS002 - Ignore log of logs
}

resource "aws_s3_bucket_public_access_block" "csv_bucket_logs" {
  bucket = aws_s3_bucket.csv_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}