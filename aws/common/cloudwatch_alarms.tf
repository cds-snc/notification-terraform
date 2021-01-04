# Note to maintainers:
# Updating alarms? Update the Google Sheet also!
# https://docs.google.com/spreadsheets/d/1gkrL3Trxw0xEkX724C1bwpfeRsTlK2X60wtCjF6MFRA/edit
#
# There are also alarms defined in aws/eks/cloudwatch_alarms.tf

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
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
}

resource "aws_cloudwatch_metric_alarm" "sns-sms-success-rate-canadian-numbers-warning" {
  alarm_name          = "sns-sms-success-rate-canadian-numbers-warning"
  alarm_description   = "SMS success rate to Canadian numbers is below 85% over the last 24 hours"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "SMSSuccessRate"
  namespace           = "AWS/SNS"
  period              = 60 * 60 * 24
  statistic           = "Average"
  threshold           = 85 / 100
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    SMSType = "Transactional"
    Country = "CA"
  }
}

resource "aws_cloudwatch_metric_alarm" "sns-sms-success-rate-canadian-numbers-critical" {
  alarm_name          = "sns-sms-success-rate-canadian-numbers-critical"
  alarm_description   = "SMS success rate to Canadian numbers is below 75% over the last 24 hours"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "SMSSuccessRate"
  namespace           = "AWS/SNS"
  period              = 60 * 60 * 24
  statistic           = "Average"
  threshold           = 75 / 100
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  dimensions = {
    SMSType = "Transactional"
    Country = "CA"
  }
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
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
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
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
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
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
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
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
}

resource "aws_cloudwatch_metric_alarm" "sqs-sms-stuck-in-queue-warning" {
  alarm_name          = "sqs-sms-stuck-in-queue-warning"
  alarm_description   = "ApproximateAgeOfOldestMessage in SMS queue is older than 3 minutes for 15 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = "300"
  extended_statistic  = "p90"
  threshold           = 60 * 3
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    QueueName = "eks-notification-canada-casend-sms-tasks"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-sms-stuck-in-queue-critical" {
  alarm_name          = "sqs-sms-stuck-in-queue-critical"
  alarm_description   = "ApproximateAgeOfOldestMessage in SMS queue is older than 5 minutes for 15 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = "300"
  extended_statistic  = "p90"
  threshold           = 60 * 5
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  dimensions = {
    QueueName = "eks-notification-canada-casend-sms-tasks"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-email-stuck-in-queue-warning" {
  alarm_name          = "sqs-email-stuck-in-queue-warning"
  alarm_description   = "ApproximateAgeOfOldestMessage in email queue is older than 10 minutes for 15 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = "300"
  extended_statistic  = "p90"
  threshold           = 60 * 10
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    QueueName = "eks-notification-canada-casend-email-tasks"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-email-stuck-in-queue-critical" {
  alarm_name          = "sqs-email-stuck-in-queue-critical"
  alarm_description   = "ApproximateAgeOfOldestMessage in email queue is older than 15 minutes for 15 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = "300"
  extended_statistic  = "p90"
  threshold           = 60 * 15
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  dimensions = {
    QueueName = "eks-notification-canada-casend-email-tasks"
  }
}

resource "aws_cloudwatch_metric_alarm" "healtheck-page-slow-response-warning" {
  alarm_name          = "healtheck-page-slow-response-warning"
  alarm_description   = "Healthcheck page response time is above 100ms for 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "production_notifications_api_GET_status_show_status_200"
  namespace           = "NotificationCanadaCa"
  period              = "300"
  statistic           = "Average"
  threshold           = 1
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  treat_missing_data  = "breaching"
  dimensions = {
    metric_type = "timing"
  }
}

resource "aws_cloudwatch_metric_alarm" "healtheck-page-slow-response-critical" {
  alarm_name          = "healtheck-page-slow-response-critical"
  alarm_description   = "Healthcheck page response time is above 200ms for 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "production_notifications_api_GET_status_show_status_200"
  namespace           = "NotificationCanadaCa"
  period              = "300"
  statistic           = "Average"
  threshold           = 2
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  treat_missing_data  = "breaching"
  dimensions = {
    metric_type = "timing"
  }
}

resource "aws_cloudwatch_metric_alarm" "no-emails-sent-5-minutes-warning" {
  alarm_name          = "no-emails-sent-1-minute-warning"
  alarm_description   = "SES sending rate is less than 1 per minute"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Delivery"
  namespace           = "AWS/SES"
  period              = "60"
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "breaching"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
}

resource "aws_cloudwatch_metric_alarm" "no-emails-sent-5-minutes-critical" {
  alarm_name          = "no-emails-sent-5-minutes-critical"
  alarm_description   = "No emails delivered with SES in 5 minutes"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Delivery"
  namespace           = "AWS/SES"
  period              = "300"
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "breaching"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
}
