#
# Heartbeat CloudWatch logging
#

resource "aws_cloudwatch_log_group" "heartbeat_log_group" {
  count             = var.cloudwatch_enabled ? 1 : 0
  name              = "heartbeat_log_group"
  retention_in_days = var.env == "production" ? 0 : 365
  tags = {
    CostCenter  = "notification-canada-ca-${var.env}"
    Environment = var.env
    Application = "lambda"
  }
}

resource "aws_cloudwatch_log_metric_filter" "heartbeat-500-errors-api" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "heartbeat-500-errors-api"
  pattern        = "\"\\\"levelname\\\": \\\"ERROR\\\"\""
  log_group_name = "/aws/lambda/${module.heartbeat.function_name}"

  metric_transformation {
    name      = "500-errors-heartbeat-api"
    namespace = "LogMetrics"
    value     = "1"
  }
}
