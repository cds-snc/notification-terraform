# Note to maintainers:
# Updating alarms? Update the Google Sheet also!
# https://docs.google.com/spreadsheets/d/1gkrL3Trxw0xEkX724C1bwpfeRsTlK2X60wtCjF6MFRA/edit
#
# There are also alarms defined in aws/common/cloudwatch_alarms.tf

resource "aws_cloudwatch_metric_alarm" "blazer-task-unavailable" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "blazer-task-unavailable"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = 1
  alarm_description         = "Unavailable Blazer task"
  alarm_actions             = [var.sns_alert_warning_arn]
  insufficient_data_actions = [var.sns_alert_warning_arn]
  ok_actions                = [var.sns_alert_warning_arn]
  treat_missing_data        = "breaching"
  threshold                 = 1

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "TaskCount"
      namespace   = "ECS/ContainerInsights"
      period      = 300
      stat        = "Maximum"
      dimensions = {
        ClusterName = "blazer"
      }
    }
  }
}
