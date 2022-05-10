# Note to maintainers:
# Updating alarms? Update the Google Sheet also!
# https://docs.google.com/spreadsheets/d/1gkrL3Trxw0xEkX724C1bwpfeRsTlK2X60wtCjF6MFRA/edit
#
# There are also alarms defined in aws/eks/cloudwatch_alarms.tf

resource "aws_cloudwatch_metric_alarm" "priority-inflights-not-being-processed-warning" {
  alarm_name          = "priority-inflights-not-being-processed-warning"
  alarm_description   = "Batch saving priority inflights are being created but are not being processed fast enough. Difference > ${var.alarm_warning_priority_inflight_processed_created_delta_threshold} for 5 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = var.alarm_warning_priority_inflight_processed_created_delta_threshold
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions    = [aws_sns_topic.notification-canada-ca-alert-ok.arn]

  metric_query {
    id    = "inflight_created"
    label = "Inflight created"

    metric {
      metric_name = "batch_saving_inflight"
      namespace   = "NotificationCanadaCa"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        created  = "True"
        priority = "priority"
      }
    }
  }

  metric_query {
    id    = "inflight_processed"
    label = "Inflight processed"

    metric {
      metric_name = "batch_saving_inflight"
      namespace   = "NotificationCanadaCa"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        acknowledged = "True"
        priority     = "priority"
      }
    }
  }

  metric_query {
    id          = "delta"
    expression  = "ABS(inflight_created - inflight_processed)"
    label       = "Delta"
    return_data = "true"
  }
}


resource "aws_cloudwatch_metric_alarm" "priority_inflights-not-being-processed-critical" {
  alarm_name          = "priority-inflights-not-being-processed-critical"
  alarm_description   = "Batch saving priority inflights are being created but are not being processed fast enough. Difference > ${var.alarm_critical_priority_inflight_processed_created_delta_threshold} for 5 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = var.alarm_critical_priority_inflight_processed_created_delta_threshold
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions    = [aws_sns_topic.notification-canada-ca-alert-ok.arn]

  metric_query {
    id    = "inflight_created"
    label = "Inflight created"

    metric {
      metric_name = "batch_saving_inflight"
      namespace   = "NotificationCanadaCa"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        created  = "True"
        priority = "priority"
      }
    }
  }

  metric_query {
    id    = "inflight_processed"
    label = "Inflight processed"

    metric {
      metric_name = "batch_saving_inflight"
      namespace   = "NotificationCanadaCa"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        acknowledged = "True"
        priority     = "priority"
      }
    }
  }

  metric_query {
    id          = "delta"
    expression  = "ABS(inflight_created - inflight_processed)"
    label       = "Delta"
    return_data = "true"
  }
}

resource "aws_cloudwatch_metric_alarm" "normal-inflights-not-being-processed-warning" {
  alarm_name          = "normal-inflights-not-being-processed-warning"
  alarm_description   = "Batch saving normal inflights are being created but are not being processed fast enough. Difference > ${var.alarm_warning_normal_inflight_processed_created_delta_threshold} for 5 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = var.alarm_warning_normal_inflight_processed_created_delta_threshold
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions    = [aws_sns_topic.notification-canada-ca-alert-ok.arn]

  metric_query {
    id    = "inflight_created"
    label = "Inflight created"

    metric {
      metric_name = "batch_saving_inflight"
      namespace   = "NotificationCanadaCa"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        created  = "True"
        priority = "normal"
      }
    }
  }

  metric_query {
    id    = "inflight_processed"
    label = "Inflight processed"

    metric {
      metric_name = "batch_saving_inflight"
      namespace   = "NotificationCanadaCa"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        acknowledged = "True"
        priority     = "normal"
      }
    }
  }

  metric_query {
    id          = "delta"
    expression  = "ABS(inflight_created - inflight_processed)"
    label       = "Delta"
    return_data = "true"
  }
}

resource "aws_cloudwatch_metric_alarm" "normal-inflights-not-being-processed-critical" {
  alarm_name          = "normal-inflights-not-being-processed-critical"
  alarm_description   = "Batch saving normal inflights are being created but are not being processed fast enough. Difference > ${var.alarm_critical_normal_inflight_processed_created_delta_threshold} for 5 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = var.alarm_warning_critical_inflight_processed_created_delta_threshold
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions    = [aws_sns_topic.notification-canada-ca-alert-ok.arn]

  metric_query {
    id    = "inflight_created"
    label = "Inflight created"

    metric {
      metric_name = "batch_saving_inflight"
      namespace   = "NotificationCanadaCa"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        created  = "True"
        priority = "normal"
      }
    }
  }

  metric_query {
    id    = "inflight_processed"
    label = "Inflight processed"

    metric {
      metric_name = "batch_saving_inflight"
      namespace   = "NotificationCanadaCa"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        acknowledged = "True"
        priority     = "normal"
      }
    }
  }

  metric_query {
    id          = "delta"
    expression  = "ABS(inflight_created - inflight_processed)"
    label       = "Delta"
    return_data = "true"
  }
}

resource "aws_cloudwatch_metric_alarm" "bulk-inflights-not-being-processed-warning" {
  alarm_name          = "bulk-inflights-not-being-processed-warning"
  alarm_description   = "Batch saving bulk inflights are being created but are not being processed fast enough. Difference > ${var.alarm_warning_bulk_inflight_processed_created_delta_threshold} for 5 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = var.alarm_warning_bulk_inflight_processed_created_delta_threshold
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions    = [aws_sns_topic.notification-canada-ca-alert-ok.arn]

  metric_query {
    id    = "inflight_created"
    label = "Inflight created"

    metric {
      metric_name = "batch_saving_inflight"
      namespace   = "NotificationCanadaCa"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        created  = "True"
        priority = "bulk"
      }
    }
  }

  metric_query {
    id    = "inflight_processed"
    label = "Inflight processed"

    metric {
      metric_name = "batch_saving_inflight"
      namespace   = "NotificationCanadaCa"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        acknowledged = "True"
        priority     = "bulk"
      }
    }
  }

  metric_query {
    id          = "delta"
    expression  = "ABS(inflight_created - inflight_processed)"
    label       = "Delta"
    return_data = "true"
  }
}

resource "aws_cloudwatch_metric_alarm" "bulk-inflights-not-being-processed-critical" {
  alarm_name          = "bulk-inflights-not-being-processed-critical"
  alarm_description   = "Batch saving bulk inflights are being created but are not being processed fast enough. Difference > ${var.alarm_critical_bulk_inflight_processed_created_delta_threshold} for 5 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = var.alarm_warning_critical_inflight_processed_created_delta_threshold
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions    = [aws_sns_topic.notification-canada-ca-alert-ok.arn]

  metric_query {
    id    = "inflight_created"
    label = "Inflight created"

    metric {
      metric_name = "batch_saving_inflight"
      namespace   = "NotificationCanadaCa"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        created  = "True"
        priority = "bulk"
      }
    }
  }

  metric_query {
    id    = "inflight_processed"
    label = "Inflight processed"

    metric {
      metric_name = "batch_saving_inflight"
      namespace   = "NotificationCanadaCa"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        acknowledged = "True"
        priority     = "bulk"
      }
    }
  }

  metric_query {
    id          = "delta"
    expression  = "ABS(inflight_created - inflight_processed)"
    label       = "Delta"
    return_data = "true"
  }
}
