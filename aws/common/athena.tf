###
# Athena deployment configuration for the Notification application
###

resource "aws_athena_database" "notification_athena" {
  name   = "notification_athena"
  bucket = aws_s3_bucket.athena_bucket.bucket

  encryption_configuration {
    encryption_option = "SSE_S3"
  }

  depends_on = [aws_s3_bucket.athena_bucket]
}
