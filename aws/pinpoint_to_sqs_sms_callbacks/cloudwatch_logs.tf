#
# SNS Receiving SMS CloudWatch logging
#

resource "aws_cloudwatch_log_group" "pinpoint_to_sqs_sms_callbacks_log_group" {
  count             = var.cloudwatch_enabled ? 1 : 0
  name              = "pinpoint_to_sqs_sms_callbacks_log_group"
  retention_in_days = var.sensitive_log_retention_period_days
  tags = {
    CostCenter  = "notification-canada-ca-${var.env}"
    Environment = var.env
    Application = "lambda"
  }
}

resource "aws_cloudwatch_log_metric_filter" "pinpoint_to_sqs_sms_callbacks-500-errors-api" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "pinpoint_to_sqs_sms_callbacks-500-errors-api"
  pattern        = "\"\\\"levelname\\\": \\\"ERROR\\\"\""
  log_group_name = "/aws/lambda/${module.pinpoint_to_sqs_sms_callbacks.function_name}"

  metric_transformation {
    name      = "500-errors-pinpoint_to_sqs_sms_callbacks-api"
    namespace = "LogMetrics"
    value     = "1"
  }
}
