# Note to maintainers:
# Updating alarms? Update the Google Sheet also!
# https://docs.google.com/spreadsheets/d/1gkrL3Trxw0xEkX724C1bwpfeRsTlK2X60wtCjF6MFRA/edit
#
# There are also alarms defined in aws/common/cloudwatch_alarms.tf

resource "aws_cloudwatch_metric_alarm" "logs-1-error-1-minute-warning-lambda-api" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "logs-1-error-1-minute-warning-lambda-api"
  alarm_description         = "One error in 1 minute for lambda api"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.errors-lambda-api[0].metric_transformation[0].name
  namespace                 = aws_cloudwatch_log_metric_filter.errors-lambda-api[0].metric_transformation[0].namespace
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = 1
  treat_missing_data        = "notBreaching"
  alarm_actions             = [var.sns_alert_warning_arn]
  ok_actions                = [var.sns_alert_warning_arn]
  insufficient_data_actions = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "logs-10-error-5-minutes-critical-lambda-api" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "logs-10-error-5-minutes-critical-lambda-api"
  alarm_description         = "Ten errors in 5 minutes for lambda api"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.errors-lambda-api[0].metric_transformation[0].name
  namespace                 = aws_cloudwatch_log_metric_filter.errors-lambda-api[0].metric_transformation[0].namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = 10
  treat_missing_data        = "notBreaching"
  alarm_actions             = [var.sns_alert_critical_arn]
  ok_actions                = [var.sns_alert_critical_arn]
  insufficient_data_actions = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "logs-1-error-1-minute-warning-salesforce-api" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "logs-1-error-1-minute-warning-salesforce-api"
  alarm_description         = "One Salesforce API error in 1 minute"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.errors-salesforce-api[0].metric_transformation[0].name
  namespace                 = aws_cloudwatch_log_metric_filter.errors-salesforce-api[0].metric_transformation[0].namespace
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = 1
  treat_missing_data        = "notBreaching"
  alarm_actions             = [var.sns_alert_warning_arn]
  ok_actions                = [var.sns_alert_warning_arn]
  insufficient_data_actions = [var.sns_alert_warning_arn]
}

module "lambda_no_log_detection" {
  count                 = var.cloudwatch_enabled ? 1 : 0
  source                = "github.com/cds-snc/terraform-modules/empty_log_group_alarm"
  alarm_sns_topic_arn   = var.sns_alert_warning_arn
  log_group_names       = ["/aws/lambda/api-lambda"]
  time_period_minutes   = 10
  use_anomaly_detection = false
  billing_tag_value     = "notification-canada-ca-${var.env}"
}

resource "aws_cloudwatch_metric_alarm" "failed-login-count-5-minute-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "failed-login-count-5-minute-warning"
  alarm_description   = "One user had a failed login count of more than 10 times in 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.failed-login-count-more-than-10[0].name
  namespace           = aws_cloudwatch_log_metric_filter.failed-login-count-more-than-10[0].metric_transformation[0].namespace
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
}


resource "aws_cloudwatch_metric_alarm" "api-gateway-timeout-5-minute-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "api-gateway-1-timeout-5-minute-warning"
  alarm_description   = "At least 1 API gateway time out in 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.api-gateway-time-out[0].name
  namespace           = aws_cloudwatch_log_metric_filter.api-gateway-time-out[0].metric_transformation[0].namespace
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "api-gateway-timeout-5-minute-critical" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "api-gateway-1-timeout-5-minute-warning"
  alarm_description   = "Requests to the API gateway timed out more than 5 times in 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.api-gateway-time-out[0].name
  namespace           = aws_cloudwatch_log_metric_filter.api-gateway-time-out[0].metric_transformation[0].namespace
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_critical_arn]
}