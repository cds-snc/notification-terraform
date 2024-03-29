#
# SES Receiving Emails CloudWatch logging
#

resource "aws_cloudwatch_log_metric_filter" "ses_receiving_emails-500-errors-api" {
  provider = aws.us-east-1

  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "ses_receiving_emails-500-errors-api"
  pattern        = "\"\\\"levelname\\\": \\\"ERROR\\\"\""
  log_group_name = "/aws/lambda/${module.ses_receiving_emails.function_name}"

  metric_transformation {
    name      = "500-errors-ses_receiving_emails-api"
    namespace = "LogMetrics"
    value     = "1"
  }
}
