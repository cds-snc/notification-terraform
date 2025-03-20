# Note to maintainers:
# Updating alarms? Update the Google Sheet also!
# https://docs.google.com/spreadsheets/d/1gkrL3Trxw0xEkX724C1bwpfeRsTlK2X60wtCjF6MFRA/edit
#

resource "aws_cloudwatch_metric_alarm" "logs-1-500-error-1-minute-warning-system_status-api" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "logs-1-500-error-1-minute-warning-system_status-api"
  alarm_description   = "One 500 error in 1 minute for system_status api"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.system_status-500-errors-api[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.system_status-500-errors-api[0].metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
  ok_actions          = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "logs-10-500-error-5-minutes-critical-system_status-api" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "logs-10-500-error-5-minutes-critical-system_status-api"
  alarm_description   = "Ten 500 errors in 5 minutes for system_status api"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.system_status-500-errors-api[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.system_status-500-errors-api[0].metric_transformation[0].namespace
  period              = "300"
  statistic           = "Sum"
  threshold           = 10
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_critical_arn]
  ok_actions          = [var.sns_alert_critical_arn]
}


# Email Down - Warning Alarm
resource "aws_cloudwatch_metric_alarm" "system_status_email_down_warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "system-status-email-down-warning"
  alarm_description   = "Email system status reported as 'down'"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.system_status_email_down[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.system_status_email_down[0].metric_transformation[0].namespace
  period              = 60 # 1 minute
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
  ok_actions          = [var.sns_alert_warning_arn]
}

# Email Degraded - Warning Alarm
resource "aws_cloudwatch_metric_alarm" "system_status_email_degraded_warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "system-status-email-degraded-warning"
  alarm_description   = "Email system status reported as 'degraded' 2 or more times in 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.system_status_email_degraded[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.system_status_email_degraded[0].metric_transformation[0].namespace
  period              = 600 # 10 minutes
  statistic           = "Sum"
  threshold           = 5
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
  ok_actions          = [var.sns_alert_warning_arn]
}

# SMS Down - Warning Alarm
resource "aws_cloudwatch_metric_alarm" "system_status_sms_down_warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "system-status-sms-down-warning"
  alarm_description   = "SMS system status reported as 'down'"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.system_status_sms_down[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.system_status_sms_down[0].metric_transformation[0].namespace
  period              = 60 # 1 minute
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
  ok_actions          = [var.sns_alert_warning_arn]
}

# SMS Degraded - Warning Alarm
resource "aws_cloudwatch_metric_alarm" "system_status_sms_degraded_warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "system-status-sms-degraded-warning"
  alarm_description   = "SMS system status reported as 'degraded' 2 or more times in 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.system_status_sms_degraded[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.system_status_sms_degraded[0].metric_transformation[0].namespace
  period              = 600 # 10 minutes
  statistic           = "Sum"
  threshold           = 5
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
  ok_actions          = [var.sns_alert_warning_arn]
}
