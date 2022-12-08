#
# SES Receiving Emails CloudWatch logging
#

resource "aws_cloudwatch_log_group" "ses_receiving_emails_log_group" {
  name              = "ses_receiving_emails_log_group"
  retention_in_days = 90
  tags = {
    CostCenter  = "notification-canada-ca-${var.env}"
    Environment = var.env
    Application = "lambda"
  }
}

resource "aws_cloudwatch_log_metric_filter" "ses_receiving_emails-500-errors-api" {
  name           = "ses_receiving_emails-500-errors-api"
  pattern        = "\"\\\"levelname\\\": \\\"ERROR\\\"\""
  log_group_name = "/aws/lambda/${module.ses_receiving_emails.function_name}"

  metric_transformation {
    name      = "500-errors-ses_receiving_emails-api"
    namespace = "LogMetrics"
    value     = "1"
  }
}
