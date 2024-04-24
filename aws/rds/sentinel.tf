locals {
  postgres_dangerous_queries       = ["ALTER", "CREATE", "DELETE", "DROP", "GRANT", "REVOKE", "TRUNCATE"]
  postgres_dangerous_queries_lower = [for sql in local.postgres_dangerous_queries : lower(sql)]
}

resource "aws_lambda_permission" "sentinel_forwarder_cloudwatch_log_subscription" {
    count = var.sentinel_forwarder_cloudwatch_lambda_name != null && var.env != "production" ? 1 : 0

    action        = "lambda:InvokeFunction"
    function_name = var.sentinel_forwarder_cloudwatch_lambda_name
    principal     = "logs.${var.region}.amazonaws.com"
    source_arn    = "${aws_cloudwatch_log_group.logs_exports.arn}:*"
    statement_id  = "AllowExecutionFromCloudWatchLogs-sentinel-cloud-watch-forwarder-postgres"
}

resource "aws_cloudwatch_log_subscription_filter" "postgresql_dangerous_queries" {
  count = var.sentinel_forwarder_cloudwatch_lambda_name != null && var.env != "production" ? 1 : 0

  name            = "Postgresql dangerous queries"
  log_group_name  = aws_cloudwatch_log_group.logs_exports.arn
  filter_pattern  = "[(w1=\"*${join("*\" || w1=\"*", concat(local.postgres_dangerous_queries, local.postgres_dangerous_queries_lower))}*\")]"
  destination_arn = var.sentinel_forwarder_cloudwatch_lambda_arn
  distribution    = "Random"
}
