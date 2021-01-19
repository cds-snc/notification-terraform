###
# Athena deployment configuration for the Notification application
###

resource "aws_athena_database" "notification_athena" {
  name   = "notification_athena"
  bucket = aws_s3_bucket.athena_bucket.bucket

  encryption_configuration {
    encryption_option = "SSE_S3"
  }
}

resource "aws_athena_workgroup" "primary" {
  name = "primary"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_bucket.bucket}"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}
