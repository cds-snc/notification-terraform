###
# Athena deployment configuration for the Notification application
###

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

  logging {
    target_bucket = aws_s3_bucket.athena_bucket_logs.bucket
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
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
    CostCenter = "notification-canada-ca-${var.env}"
  }

  #tfsec:ignore:AWS002 - Ignore log of logs
}

resource "aws_athena_workgroup" "notification_athena_workgroup" {
  name = "notification_athena_workgroup"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_bucket.bucket}/output/"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_athena_database" "notification_athena" {
  name   = "notification_athena"
  bucket = aws_s3_bucket.athena_bucket.bucket
}
