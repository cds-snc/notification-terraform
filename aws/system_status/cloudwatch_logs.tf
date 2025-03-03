#
# System Status CloudWatch logging
#

resource "aws_cloudwatch_log_group" "system_status_log_group" {
  count             = var.cloudwatch_enabled ? 1 : 0
  name              = "system_status_log_group"
  retention_in_days = var.log_retention_period_days
  tags = {
    CostCenter  = "notification-canada-ca-${var.env}"
    Environment = var.env
    Application = "lambda"
  }
}

resource "aws_cloudwatch_log_metric_filter" "system_status-500-errors-api" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "system_status-500-errors-api"
  pattern        = "\"[ERROR]\""
  log_group_name = "/aws/lambda/${module.system_status.function_name}"

  metric_transformation {
    name      = "500-errors-system_status-api"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "system_status_email_down" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "system_status_email_down"
  pattern        = "'email': 'down'"
  log_group_name = "/aws/lambda/${module.system_status.function_name}"

  metric_transformation {
    name      = "500-errors-system_status-api"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "system_status_email_degraded" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "system_status_email_degraded"
  pattern        = "'email': 'degraded'"
  log_group_name = "/aws/lambda/${module.system_status.function_name}"

  metric_transformation {
    name      = "500-errors-system_status-api"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "system_status_sms_down" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "system_status_sms_down"
  pattern        = "'sms': 'down'"
  log_group_name = "/aws/lambda/${module.system_status.function_name}"

  metric_transformation {
    name      = "500-errors-system_status-api"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "system_status_sms_degraded" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "system_status_sms_degraded"
  pattern        = "'sms': 'degraded'"
  log_group_name = "/aws/lambda/${module.system_status.function_name}"

  metric_transformation {
    name      = "500-errors-system_status-api"
    namespace = "LogMetrics"
    value     = "1"
  }
}