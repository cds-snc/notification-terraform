resource "aws_athena_named_query" "create_table_alb_logs" {
  name        = "create_table_alb_logs"
  description = "TF: Create table for ALB logs: alb_logs"
  workgroup   = aws_athena_workgroup.build_tables.name
  database    = aws_athena_database.notification_athena.name
  query = templatefile("${path.module}/sql/alb_log_create_table.sql.tmpl",
    {
      database_name   = aws_athena_database.notification_athena.name
      table_name      = "alb_logs"
      bucket_location = "s3://cbs-satellite-${var.account_id}/lb_logs/AWSLogs/${var.account_id}/elasticloadbalancing/${var.region}/"
  })
}

resource "aws_athena_named_query" "create_table_waf_logs" {
  name        = "WAF: create table waf_logs_lb"
  description = "TF: Create table for k8s WAF logs: waf_logs_lb"
  workgroup   = aws_athena_workgroup.build_tables.name
  database    = aws_athena_database.notification_athena.name
  query = templatefile("${path.module}/sql/waf_log_create_table.sql.tmpl",
    {
      database_name   = aws_athena_database.notification_athena.name
      table_name      = "waf_logs_lb"
      bucket_location = "s3://cbs-satellite-${var.account_id}/waf_acl_logs/AWSLogs/${var.account_id}/lb/"
  })
}

resource "aws_athena_named_query" "create_table_waf_logs_api_lambda" {
  name        = "WAF: create table waf_logs_api_lambda"
  description = "TF: Create table for api lambda WAF logs: waf_logs_api_lambda"
  workgroup   = aws_athena_workgroup.build_tables.name
  database    = aws_athena_database.notification_athena.name
  query = templatefile("${path.module}/sql/waf_log_create_table.sql.tmpl",
    {
      database_name   = aws_athena_database.notification_athena.name
      table_name      = "waf_logs_api_lambda"
      bucket_location = "s3://cbs-satellite-${var.account_id}/waf_acl_logs/AWSLogs/${var.account_id}/lambda/"
  })
}

resource "aws_athena_named_query" "create_table_all_waf_logs" {
  name        = "WAF: create table waf_logs"
  description = "TF: Create table containing both k8s and api-lambda WAF logs: waf_logs"
  workgroup   = aws_athena_workgroup.build_tables.name
  database    = aws_athena_database.notification_athena.name
  query = templatefile("${path.module}/sql/waf_log_create_table.sql.tmpl",
    {
      database_name   = aws_athena_database.notification_athena.name
      table_name      = "waf_logs"
      bucket_location = "s3://cbs-satellite-${var.account_id}/waf_acl_logs/AWSLogs/${var.account_id}/"
  })
}

resource "aws_athena_named_query" "create_cloudfront_logs" {
  name        = "Create CloudFront logs"
  description = "Create CloudFront logs table cloudfront_logs"
  workgroup   = aws_athena_workgroup.build_tables.name
  database    = aws_athena_database.notification_athena.name
  query       = templatefile("${path.module}/sql/create_cloudfront_logs.sql.tmpl", {})
}
