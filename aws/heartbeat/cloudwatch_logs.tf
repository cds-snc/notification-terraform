#
# Heartbeat CloudWatch logging
#

resource "aws_cloudwatch_log_group" "heartbeat_log_group" {
  name              = "heartbeat_log_group"
  retention_in_days = 90
  tags = {
    CostCentre  = "notification-canada-ca-${var.env}"
    Terraform   = true
    Environment = var.env
    Application = "lambda"
  }
}

resource "aws_cloudwatch_log_metric_filter" "heartbeat-500-errors-api" {
  name           = "heartbeat-500-errors-api"
  pattern        = "\"\\\"levelname\\\": \\\"ERROR\\\"\""
  log_group_name = "/aws/lambda/${module.heartbeat.function_name}"

  metric_transformation {
    name      = "500-errors-heartbeat-api"
    namespace = "LogMetrics"
    value     = "1"
  }
  tags = {
    CostCentre = "notification-canada-ca-${var.env}"
    Terraform  = true
  }
}
