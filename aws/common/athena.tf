###
# Athena deployment configuration for Notify
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

resource "aws_athena_named_query" "create_table_alb_logs" {
  name      = "create_table_alb_logs"
  workgroup = aws_athena_workgroup.primary.name
  database  = aws_athena_database.notification_athena.name
  query = templatefile("${path.module}/sql/alb_log_create_table.sql.tmpl",
    {
      database_name   = aws_athena_database.notification_athena.name
      table_name      = "alb_logs"
      bucket_location = "s3://${var.cbs_satellite_bucket_name}/lb_logs/AWSLogs/${var.account_id}/elasticloadbalancing/${var.region}/"
  })
}

resource "aws_athena_named_query" "create_table_waf_logs" {
  name      = "create_table_waf_logs"
  workgroup = aws_athena_workgroup.primary.name
  database  = aws_athena_database.notification_athena.name
  query = templatefile("${path.module}/sql/waf_log_create_table.sql.tmpl",
    {
      database_name   = aws_athena_database.notification_athena.name
      table_name      = "waf_logs"
      bucket_location = "s3://${var.cbs_satellite_bucket_name}/waf_acl_logs/AWSLogs/${var.account_id}/lb/${var.region}/"
  })
}
