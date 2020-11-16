resource "aws_cloudwatch_metric_alarm" "sns-spending-warning" {
  alarm_name          = "sns-spending-warning"
  alarm_description   = "SNS spending reached 80% of limit this month"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "SMSMonthToDateSpentUSD"
  namespace           = "AWS/SNS"
  period              = "300"
  statistic           = "Maximum"
  threshold           = 0.8 * var.sns_monthly_spend_limit
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
}

resource "aws_cloudwatch_metric_alarm" "sns-spending-critical" {
  alarm_name          = "sns-spending-critical"
  alarm_description   = "SNS spending reached 90% of limit this month"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "SMSMonthToDateSpentUSD"
  namespace           = "AWS/SNS"
  period              = "300"
  statistic           = "Maximum"
  threshold           = 0.9 * var.sns_monthly_spend_limit
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
}

resource "aws_cloudwatch_metric_alarm" "ses-bounce-rate-warning" {
  alarm_name          = "ses-bounce-rate-warning"
  alarm_description   = "Bounce rate >=5% over the last 12 hours"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Reputation.BounceRate"
  namespace           = "AWS/SES"
  period              = 60 * 60 * 12
  statistic           = "Average"
  threshold           = 5 / 100
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
}

resource "aws_cloudwatch_metric_alarm" "ses-bounce-rate-critical" {
  alarm_name          = "ses-bounce-rate-critical"
  alarm_description   = "Bounce rate >=7% over the last 12 hours"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Reputation.BounceRate"
  namespace           = "AWS/SES"
  period              = 60 * 60 * 12
  statistic           = "Average"
  threshold           = 7 / 100
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
}


resource "aws_cloudwatch_metric_alarm" "ses-complaint-rate-warning" {
  alarm_name          = "ses-complaint-rate-warning"
  alarm_description   = "Complaint rate >=0.3% over the last 12 hours"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Reputation.ComplaintRate"
  namespace           = "AWS/SES"
  period              = 60 * 60 * 12
  statistic           = "Average"
  threshold           = 0.3 / 100
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
}

resource "aws_cloudwatch_metric_alarm" "ses-complaint-rate-critical" {
  alarm_name          = "ses-complaint-rate-critical"
  alarm_description   = "Complaint rate >=0.4% over the last 12 hours"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Reputation.ComplaintRate"
  namespace           = "AWS/SES"
  period              = 60 * 60 * 12
  statistic           = "Average"
  threshold           = 0.4 / 100
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
}

resource "aws_cloudwatch_metric_alarm" "sqs-sms-stuck-in-queue" {
  alarm_name          = "sqs-sms-stuck-in-queue"
  alarm_description   = "ApproximateAgeOfOldestMessage in SMS queue is older than 5 minutes for 15 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = "300"
  extended_statistic  = "p90"
  threshold           = 60 * 5
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  dimensions = {
    QueueName = "eks-notification-canada-casend-sms-tasks"
  }
}

resource "aws_cloudwatch_metric_alarm" "healtheck-page-slow-reponse" {
  alarm_name          = "healtheck-page-slow-reponse"
  alarm_description   = "Healthcheck page response time is above 200ms for 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "production_notifications_app_GET_status_show_status_200"
  namespace           = "CWAgent"
  period              = "300"
  extended_statistic  = "Average"
  threshold           = 2
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
}
