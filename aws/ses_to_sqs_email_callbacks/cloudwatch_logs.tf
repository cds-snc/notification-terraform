#
# SES Receiving Emails CloudWatch logging
#

resource "aws_cloudwatch_log_group" "ses_to_sqs_email_callbacks_log_group" {
  count             = var.cloudwatch_enabled ? 1 : 0
  name              = "ses_to_sqs_email_callbacks_log_group"
  retention_in_days = var.env == "production" ? 0 : 365
  tags = {
    CostCenter  = "notification-canada-ca-${var.env}"
    Environment = var.env
    Application = "lambda"
  }
}

resource "aws_cloudwatch_log_metric_filter" "ses_to_sqs_email_callbacks-500-errors-api" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "ses_to_sqs_email_callbacks-500-errors-api"
  pattern        = "\"\\\"levelname\\\": \\\"ERROR\\\"\""
  log_group_name = "/aws/lambda/${module.ses_to_sqs_email_callbacks.function_name}"

  metric_transformation {
    name      = "500-errors-ses_to_sqs_email_callbacks-api"
    namespace = "LogMetrics"
    value     = "1"
  }
}
