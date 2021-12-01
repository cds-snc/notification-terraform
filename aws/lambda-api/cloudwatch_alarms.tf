# Note to maintainers:
# Updating alarms? Update the Google Sheet also!
# https://docs.google.com/spreadsheets/d/1gkrL3Trxw0xEkX724C1bwpfeRsTlK2X60wtCjF6MFRA/edit
#
# There are also alarms defined in aws/common/cloudwatch_alarms.tf

resource "aws_cloudwatch_metric_alarm" "logs-1-500-error-1-minute-warning-lambda-api" {
  alarm_name          = "logs-1-500-error-1-minute-warning-lambda-api"
  alarm_description   = "One 500 error in 1 minute for lambda api"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.web-500-errors-lambda-api.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.web-500-errors-lambda-api.metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "logs-10-500-error-5-minutes-critical-lambda-api" {
  alarm_name          = "logs-10-500-error-5-minutes-critical-lambda-api"
  alarm_description   = "Ten 500 errors in 5 minutes for lambda api"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.web-500-errors-lambda-api.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.web-500-errors-lambda-api.metric_transformation[0].namespace
  period              = "300"
  statistic           = "Sum"
  threshold           = 10
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_critical_arn]
  ok_actions          = [var.sns_alert_critical_arn]
}
