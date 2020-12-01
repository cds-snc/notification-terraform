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

resource "aws_s3_bucket" "bulk_send" {
  bucket = "notification-canada-ca-${var.env}-bulk-send"
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
      days = 7
    }
  }

  logging {
    target_bucket = aws_s3_bucket.bulk_send_logs.bucket
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_s3_bucket_public_access_block" "bulk_send" {
  bucket = aws_s3_bucket.bulk_send.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "bulk_send_logs" {
  bucket = "notification-canada-ca-${var.env}-bulk-send-logs"
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
  bucket = aws_s3_bucket.csv_bucket_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "asset_bucket" {
  bucket = "notification-canada-ca-${var.env}-asset-upload"
  #tfsec:ignore:AWS001 - Public read access
  acl = "public-read"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }

  #tfsec:ignore:AWS002 - No logging enabled
  #tfsec:ignore:AWS017 - Defines an unencrypted S3 bucket
}

resource "aws_s3_bucket_policy" "asset_bucket_public_read" {
  bucket = aws_s3_bucket.asset_bucket.id

  policy = <<POLICY
{
   "Version":"2008-10-17",
   "Statement":[
      {
         "Sid":"AllowPublicRead",
         "Effect":"Allow",
         "Principal":{
            "AWS":"*"
         },
         "Action":"s3:GetObject",
         "Resource":"${aws_s3_bucket.asset_bucket.arn}/*"
      }
   ]
}
POLICY
}

resource "aws_s3_bucket" "legacy_asset_bucket" {
  count = var.env == "production" ? 1 : 0

  bucket = "notification-alpha-canada-ca-asset-upload"
  #tfsec:ignore:AWS001 - Public read access
  acl = "public-read"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }

  #tfsec:ignore:AWS002 - No logging enabled
  #tfsec:ignore:AWS017 - Defines an unencrypted S3 bucket
}

resource "aws_s3_bucket_policy" "legacy_asset_bucket_public_read" {
  count = var.env == "production" ? 1 : 0

  bucket = aws_s3_bucket.legacy_asset_bucket[0].id

  policy = <<POLICY
{
   "Version":"2008-10-17",
   "Statement":[
      {
         "Sid":"AllowPublicRead",
         "Effect":"Allow",
         "Principal":{
            "AWS":"*"
         },
         "Action":"s3:GetObject",
         "Resource":"${aws_s3_bucket.legacy_asset_bucket[0].arn}/*"
      }
   ]
}
POLICY
}

resource "aws_s3_bucket" "document_bucket" {
  bucket = "notification-canada-ca-${var.env}-document-download"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = aws_s3_bucket.document_bucket_logs.bucket
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_s3_bucket_public_access_block" "document_bucket" {
  bucket = aws_s3_bucket.document_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "document_bucket_logs" {
  bucket = "notification-canada-ca-${var.env}-document-download-logs"
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

resource "aws_s3_bucket_public_access_block" "document_bucket_logs" {
  bucket = aws_s3_bucket.document_bucket_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "alb_log_bucket" {
  bucket = "notification-canada-ca-${var.env}-alb-logs"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = aws_s3_bucket.document_bucket_logs.bucket
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }

  #tfsec:ignore:AWS002 - Ignore log of logs
}

resource "aws_s3_bucket_public_access_block" "alb_log_bucket" {
  bucket = aws_s3_bucket.alb_log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
