#
# Pinpoint will log delivery receipts to these two log groups
#

resource "aws_cloudwatch_log_group" "pinpoint_deliveries" {
  name              = "sns/${var.region}/${var.account_id}/PinPointDirectPublishToPhoneNumber"
  retention_in_days = var.sensitive_log_retention_period_days
  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_cloudwatch_log_group" "pinpoint_deliveries_failures" {
  name              = "sns/${var.region}/${var.account_id}/PinPointDirectPublishToPhoneNumber/Failure"
  retention_in_days = var.sensitive_log_retention_period_days
  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

#
# pinpoint_to_sqs_sms_callbacks lambda function logs
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
