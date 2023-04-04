#
# SES Receiving Emails CloudWatch logging
#

resource "aws_cloudwatch_log_group" "ses_to_sqs_email_callbacks_log_group" {
  name              = "ses_to_sqs_email_callbacks_log_group"
  retention_in_days = 90
  tags = {
    CostCentre  = "notification-canada-ca-${var.env}"
    Environment = var.env
    Application = "lambda"
  }
}

resource "aws_cloudwatch_log_metric_filter" "ses_to_sqs_email_callbacks-500-errors-api" {
  name           = "ses_to_sqs_email_callbacks-500-errors-api"
  pattern        = "\"\\\"levelname\\\": \\\"ERROR\\\"\""
  log_group_name = "/aws/lambda/${module.ses_to_sqs_email_callbacks.function_name}"

  metric_transformation {
    name      = "500-errors-ses_to_sqs_email_callbacks-api"
    namespace = "LogMetrics"
    value     = "1"
  }
}
