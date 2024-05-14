# Note to maintainers:
# Updating alarms? Update the Google Sheet also!
# https://docs.google.com/spreadsheets/d/1gkrL3Trxw0xEkX724C1bwpfeRsTlK2X60wtCjF6MFRA/edit
#

resource "aws_cloudwatch_metric_alarm" "logs-1-500-error-1-minute-warning-pinpoint_to_sqs_sms_callbacks-api" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "logs-1-500-error-1-minute-warning-pinpoint_to_sqs_sms_callbacks-api"
  alarm_description   = "One 500 error in 1 minute for pinpoint_to_sqs_sms_callbacks api"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.pinpoint_to_sqs_sms_callbacks-500-errors-api[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.pinpoint_to_sqs_sms_callbacks-500-errors-api[0].metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
  ok_actions          = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "logs-10-500-error-5-minutes-critical-pinpoint_to_sqs_sms_callbacks-api" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "logs-10-500-error-5-minutes-critical-pinpoint_to_sqs_sms_callbacks-api"
  alarm_description   = "Ten 500 errors in 5 minutes for pinpoint_to_sqs_sms_callbacks api"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.pinpoint_to_sqs_sms_callbacks-500-errors-api[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.pinpoint_to_sqs_sms_callbacks-500-errors-api[0].metric_transformation[0].namespace
  period              = "300"
  statistic           = "Sum"
  threshold           = 10
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_critical_arn]
  ok_actions          = [var.sns_alert_ok_arn]
}

resource "aws_cloudwatch_metric_alarm" "lambda-image-pinpoint-delivery-receipts-errors-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "lambda-image-pinpoint-delivery-receipts-errors-warning"
  alarm_description   = "5 errors on Lambda pinpoint-to-sqs-sms-callbacks in 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60 * 10
  statistic           = "Sum"
  threshold           = 5
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
  ok_actions          = [var.sns_alert_ok_arn]
  dimensions = {
    FunctionName = module.pinpoint_to_sqs_sms_callbacks.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda-image-pinpoint-delivery-receipts-errors-critical" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "lambda-image-pinpoint-delivery-receipts-errors-critical"
  alarm_description   = "20 errors on Lambda pinpoint-to-sqs-sms-callbacks in 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60 * 10
  statistic           = "Sum"
  threshold           = 20
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_critical_arn]
  ok_actions          = [var.sns_alert_ok_arn]
  dimensions = {
    FunctionName = module.pinpoint_to_sqs_sms_callbacks.function_name
  }
}
