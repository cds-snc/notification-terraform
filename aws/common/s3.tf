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
      days = 7
    }
  }

  #tfsec:ignore:AWS077 - Versioning is not enabled
  logging {
    target_bucket = aws_s3_bucket.csv_bucket_logs.bucket
  }

  tags = {
    CostCentre = "notification-canada-ca-${var.env}"
    Terraform  = true
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
    CostCentre = "notification-canada-ca-${var.env}"
    Terraform  = true
  }

  #tfsec:ignore:AWS002 - Ignore log of logs
  #tfsec:ignore:AWS077 - Versioning is not enabled
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

  #tfsec:ignore:AWS077 - Versioning is not enabled
  logging {
    target_bucket = aws_s3_bucket.bulk_send_logs.bucket
  }

  tags = {
    CostCentre = "notification-canada-ca-${var.env}"
    Terraform  = true
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
    CostCentre = "notification-canada-ca-${var.env}"
    Terraform  = true
  }

  #tfsec:ignore:AWS002 - Ignore log of logs
  #tfsec:ignore:AWS077 - Versioning is not enabled
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
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    CostCentre = "notification-canada-ca-${var.env}"
    Terraform  = true
  }

  #tfsec:ignore:AWS002 - No logging enabled
  #tfsec:ignore:AWS077 - Versioning is not enabled
}

resource "aws_s3_bucket_public_access_block" "asset_bucket" {
  bucket = aws_s3_bucket.asset_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "legacy_asset_bucket" {
  count = var.env == "production" ? 1 : 0

  bucket = "notification-alpha-canada-ca-asset-upload"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    CostCentre = "notification-canada-ca-${var.env}"
    Terraform  = true
  }

  #tfsec:ignore:AWS002 - No logging enabled
  #tfsec:ignore:AWS077 - Versioning is not enabled
}

resource "aws_s3_bucket_public_access_block" "legacy_asset_bucket" {
  count = var.env == "production" ? 1 : 0

  bucket = aws_s3_bucket.legacy_asset_bucket[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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

  # expire linked files after 7 days
  lifecycle_rule {
    id      = "tf-s3-lifecycle-linked-files"
    enabled = true

    expiration {
      days = 7
    }
  }

  # Expire files attached directly to emails after a few days.
  # Those are stored in a `tmp/` folder.
  # See https://github.com/cds-snc/notification-document-download-api
  lifecycle_rule {
    id      = "tf-s3-lifecycle-attached-files"
    enabled = true
    prefix  = "tmp/"

    expiration {
      days = 3
    }
  }

  #tfsec:ignore:AWS077 - Versioning is not enabled
  logging {
    target_bucket = aws_s3_bucket.document_bucket_logs.bucket
  }

  tags = {
    CostCentre = "notification-canada-ca-${var.env}"
    Terraform  = true
  }
}

resource "aws_s3_bucket" "scan_files_document_bucket" {
  bucket = "notification-canada-ca-${var.env}-document-download-scan-files"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # expire all files after 1 day
  lifecycle_rule {
    id      = "tf-s3-lifecycle-all-files"
    enabled = true

    expiration {
      days = 1
    }
  }

  #tfsec:ignore:AWS077 - Versioning is not enabled
  logging {
    target_bucket = aws_s3_bucket.document_bucket_logs.bucket
  }

  tags = {
    CostCentre = "notification-canada-ca-${var.env}"
    Terraform  = true
  }
}

resource "aws_s3_bucket_public_access_block" "document_bucket" {
  bucket = aws_s3_bucket.document_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "scan_files_document_bucket" {
  bucket = aws_s3_bucket.scan_files_document_bucket.id

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
    CostCentre = "notification-canada-ca-${var.env}"
    Terraform  = true
  }

  #tfsec:ignore:AWS002 - Ignore log of logs
  #tfsec:ignore:AWS077 - Versioning is not enabled
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

  lifecycle_rule {
    enabled = true

    expiration {
      days = 90
    }
  }

  tags = {
    CostCentre = "notification-canada-ca-${var.env}"
    Terraform  = true
  }

  #tfsec:ignore:AWS002 - Ignore log of logs
  #tfsec:ignore:AWS077 - Versioning is not enabled
}

resource "aws_s3_bucket_public_access_block" "alb_log_bucket" {
  bucket = aws_s3_bucket.alb_log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "alb_log_bucket_allow_elb_account" {
  bucket = aws_s3_bucket.alb_log_bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.elb_account_ids[var.region]}:root"
      },
      "Action": "s3:PutObject",
      "Resource":"${aws_s3_bucket.alb_log_bucket.arn}/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource":"${aws_s3_bucket.alb_log_bucket.arn}/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "${aws_s3_bucket.alb_log_bucket.arn}"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "athena_bucket" {
  bucket = "notification-canada-ca-${var.env}-athena"
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

  #tfsec:ignore:AWS077 - Versioning is not enabled
  logging {
    target_bucket = aws_s3_bucket.athena_bucket_logs.bucket
  }

  tags = {
    CostCentre = "notification-canada-ca-${var.env}"
    Terraform  = true
  }
}

resource "aws_s3_bucket_public_access_block" "athena_bucket" {
  bucket = aws_s3_bucket.athena_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "athena_bucket_logs" {
  bucket = "notification-canada-ca-${var.env}-athena-logs"
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
    CostCentre = "notification-canada-ca-${var.env}"
    Terraform  = true
  }

  #tfsec:ignore:AWS002 - Ignore log of logs
  #tfsec:ignore:AWS077 - Versioning is not enabled
}
