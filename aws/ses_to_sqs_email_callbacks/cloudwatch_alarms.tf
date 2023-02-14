# Note to maintainers:
# Updating alarms? Update the Google Sheet also!
# https://docs.google.com/spreadsheets/d/1gkrL3Trxw0xEkX724C1bwpfeRsTlK2X60wtCjF6MFRA/edit
#

resource "aws_cloudwatch_metric_alarm" "logs-1-500-error-1-minute-warning-ses_to_sqs_email_callbacks-api" {
  alarm_name          = "logs-1-500-error-1-minute-warning-ses_to_sqs_email_callbacks-api"
  alarm_description   = "One 500 error in 1 minute for ses_to_sqs_email_callbacks api"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.ses_to_sqs_email_callbacks-500-errors-api.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.ses_to_sqs_email_callbacks-500-errors-api.metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
  ok_actions          = [var.sns_alert_ok_arn]
}

resource "aws_cloudwatch_metric_alarm" "logs-10-500-error-5-minutes-critical-ses_to_sqs_email_callbacks-500-errors-api" {
  alarm_name          = "logs-10-500-error-5-minutes-critical-ses_to_sqs_email_callbacks-500-errors-api"
  alarm_description   = "Ten 500 errors in 5 minutes for ses_to_sqs_email_callbacks-500-errors api"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.ses_to_sqs_email_callbacks-500-errors-api.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.ses_to_sqs_email_callbacks-500-errors-api.metric_transformation[0].namespace
  period              = "300"
  statistic           = "Sum"
  threshold           = 10
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_critical_arn]
  ok_actions          = [var.sns_alert_ok_arn]
}

resource "aws_cloudwatch_metric_alarm" "lambda-ses-delivery-receipts-errors-warning" {
  alarm_name          = "lambda-ses-delivery-receipts-errors-warning"
  alarm_description   = "5 errors on Lambda ses-to-sqs-email-callbacks in 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60 * 10
  statistic           = "Sum"
  threshold           = 5
  alarm_actions       = [var.sns_alert_warning_arn]
  ok_actions          = [var.sns_alert_ok_arn]
  dimensions = {
    FunctionName = module.ses_to_sqs_email_callbacks.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda-ses-delivery-receipts-errors-critical" {
  alarm_name          = "lambda-ses-delivery-receipts-errors-critical"
  alarm_description   = "10 errors on Lambda ses-to-sqs-email-callbacks in 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60 * 10
  statistic           = "Sum"
  threshold           = 10
  alarm_actions       = [var.sns_alert_critical_arn]
  ok_actions          = [var.sns_alert_ok_arn]
  dimensions = {
    FunctionName = module.ses_to_sqs_email_callbacks.function_name
  }
}
