resource "aws_cloudwatch_metric_alarm" "load-balancer-1-500-error-1-minute-warning" {
  alarm_name          = "load-balancer-1-500-error-1-minute-warning"
  alarm_description   = "One 500 error in 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_ELB_500_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = 1
  alarm_actions       = [var.sns_alert_warning_arn]
  dimensions = {
    LoadBalancer = aws_alb.notification-canada-ca.arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "load-balancer-10-500-error-5-minutes-critical" {
  alarm_name          = "load-balancer-10-500-error-5-minutes-critical"
  alarm_description   = "Ten 500 errors in 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_ELB_500_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  statistic           = "Sum"
  threshold           = 10
  alarm_actions       = [var.sns_alert_critical_arn]
  dimensions = {
    LoadBalancer = aws_alb.notification-canada-ca.arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "logs-1-celery-error-1-minute-warning" {
  alarm_name          = "logs-1-celery-error-1-minute-warning"
  alarm_description   = "One Celery error in 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.celery-error.metric_transformation.name
  namespace           = aws_cloudwatch_log_metric_filter.celery-error.metric_transformation.namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = 1
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
}

resource "aws_cloudwatch_metric_alarm" "logs-10-celery-error-1-minute-critical" {
  alarm_name          = "logs-10-celery-error-1-minute-critical"
  alarm_description   = "Ten Celery errors in 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.celery-error.metric_transformation.name
  namespace           = aws_cloudwatch_log_metric_filter.celery-error.metric_transformation.namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = 10
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
}

resource "aws_cloudwatch_metric_alarm" "logs-1-500-error-1-minute-warning" {
  alarm_name          = "logs-1-500-error-1-minute-warning"
  alarm_description   = "One 500 error in 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.web-500-errors.metric_transformation.name
  namespace           = aws_cloudwatch_log_metric_filter.web-500-errors.metric_transformation.namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = 1
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
}

resource "aws_cloudwatch_metric_alarm" "logs-10-500-error-5-minutes-critical" {
  alarm_name          = "logs-10-500-error-5-minutes-critical"
  alarm_description   = "Ten 500 errors in 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "aws_cloudwatch_log_metric_filter.500-errors.metric_transformation.name"
  namespace           = "aws_cloudwatch_log_metric_filter.500-errors.metric_transformation.namespace"
  period              = "300"
  statistic           = "Sum"
  threshold           = 10
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
}
