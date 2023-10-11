# Note to maintainers:
# Updating alarms? Update the Google Sheet also!
# https://docs.google.com/spreadsheets/d/1gkrL3Trxw0xEkX724C1bwpfeRsTlK2X60wtCjF6MFRA/edit
#
# There are also alarms defined in aws/eks/cloudwatch_alarms.tf


resource "aws_cloudwatch_metric_alarm" "ses-bounce-rate-warning" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "ses-bounce-rate-warning"
  alarm_description         = "Bounce rate >=5% over the last 12 hours"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "Reputation.BounceRate"
  namespace                 = "AWS/SES"
  period                    = 60 * 60 * 12
  statistic                 = "Average"
  threshold                 = 5 / 100
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  treat_missing_data        = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "ses-bounce-rate-critical" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "ses-bounce-rate-critical"
  alarm_description         = "Bounce rate >=7% over the last 12 hours"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "Reputation.BounceRate"
  namespace                 = "AWS/SES"
  period                    = 60 * 60 * 12
  statistic                 = "Average"
  threshold                 = 7 / 100
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions                = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  treat_missing_data        = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "ses-complaint-rate-warning" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "ses-complaint-rate-warning"
  alarm_description         = "Complaint rate >=0.3% over the last 12 hours"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "Reputation.ComplaintRate"
  namespace                 = "AWS/SES"
  period                    = 60 * 60 * 12
  statistic                 = "Average"
  threshold                 = 0.3 / 100
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  treat_missing_data        = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "ses-complaint-rate-critical" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "ses-complaint-rate-critical"
  alarm_description         = "Complaint rate >=0.4% over the last 12 hours"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "Reputation.ComplaintRate"
  namespace                 = "AWS/SES"
  period                    = 60 * 60 * 12
  statistic                 = "Average"
  threshold                 = 0.4 / 100
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions                = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  treat_missing_data        = "notBreaching"
}

# TODO: delete this alarm and queue once we verify that we've transitioned to the new ones
resource "aws_cloudwatch_metric_alarm" "sqs-email-queue-delay-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "sqs-email-queue-delay-warning"
  alarm_description   = "ApproximateAgeOfOldestMessage in email queue >= 30 minutes for 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Maximum"
  threshold           = 60 * 30
  treat_missing_data  = "missing"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_email_queue_name}"
  }
}

# TODO: delete this alarm and queue once we verify that we've transitioned to the new ones
resource "aws_cloudwatch_metric_alarm" "sqs-email-queue-delay-critical" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "sqs-email-queue-delay-critical"
  alarm_description         = "ApproximateAgeOfOldestMessage in email queue >= 45 minutes for 5 minutes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "5"
  metric_name               = "ApproximateAgeOfOldestMessage"
  namespace                 = "AWS/SQS"
  period                    = 60
  statistic                 = "Maximum"
  threshold                 = 60 * 45
  treat_missing_data        = "missing"
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions                = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_email_queue_name}"
  }
}


resource "aws_cloudwatch_metric_alarm" "sqs-send-email-high-queue-delay-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "sqs-send-email-high-queue-delay-warning"
  alarm_description   = "ApproximateAgeOfOldestMessage in send email high priority queue >= 20 seconds for 3 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Average"
  threshold           = 20
  treat_missing_data  = "missing"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_send_email_high_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-send-email-high-queue-delay-critical" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "sqs-send-email-high-queue-delay-critical"
  alarm_description         = "ApproximateAgeOfOldestMessage in send-email-high queue >= 60 seconds for 5 minutes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "6"
  metric_name               = "ApproximateAgeOfOldestMessage"
  namespace                 = "AWS/SQS"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 60
  datapoints_to_alarm       = 6
  treat_missing_data        = "missing"
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions                = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_send_email_high_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-send-email-medium-queue-delay-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "sqs-send-email-medium-queue-delay-warning"
  alarm_description   = "ApproximateAgeOfOldestMessage in send-email-medium queue is >= 30 minutes for 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Average"
  threshold           = 60 * 30
  treat_missing_data  = "missing"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_send_email_medium_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-send-email-medium-queue-delay-critical" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "sqs-send-email-medium-queue-delay-critical"
  alarm_description         = "ApproximateAgeOfOldestMessage in send-email-medium queue is >= 45 minutes for 5 minutes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "5"
  metric_name               = "ApproximateAgeOfOldestMessage"
  namespace                 = "AWS/SQS"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 60 * 45
  treat_missing_data        = "missing"
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions                = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_send_email_medium_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-send-email-low-queue-delay-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "sqs-send-email-low-queue-delay-warning"
  alarm_description   = "ApproximateAgeOfOldestMessage in send-email-low queue is >= 1 hour for 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Average"
  threshold           = 60 * 60
  treat_missing_data  = "missing"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_send_email_low_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-send-email-low-queue-delay-critical" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "sqs-send-email-low-queue-delay-critical"
  alarm_description         = "ApproximateAgeOfOldestMessage in send-email-low queue is >= 3 hours"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "ApproximateAgeOfOldestMessage"
  namespace                 = "AWS/SQS"
  period                    = 60
  statistic                 = "Maximum"
  threshold                 = 60 * 60 * 3
  treat_missing_data        = "missing"
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions                = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_send_email_low_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "no-emails-sent-5-minutes-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "no-emails-sent-5-minutes-critical"
  alarm_description         = "No emails delivered with SES in 5 minutes"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "Delivery"
  namespace                 = "AWS/SES"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = 1
  treat_missing_data        = "breaching"
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions                = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
}
