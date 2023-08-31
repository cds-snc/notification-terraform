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
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
}

resource "aws_cloudwatch_metric_alarm" "sns-spending-us-west-2-warning" {
  provider = aws.us-west-2

  alarm_name          = "sns-spending-us-west-2-warning"
  alarm_description   = "SNS spending reached 80% of limit this month"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "SMSMonthToDateSpentUSD"
  namespace           = "AWS/SNS"
  period              = "300"
  statistic           = "Maximum"
  threshold           = 0.8 * var.sns_monthly_spend_limit_us_west_2
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning-us-west-2.arn]
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
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
}

resource "aws_cloudwatch_metric_alarm" "sns-spending-us-west-2-critical" {
  provider = aws.us-west-2

  alarm_name          = "sns-spending-us-west-2-critical"
  alarm_description   = "SNS spending reached 90% of limit this month"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "SMSMonthToDateSpentUSD"
  namespace           = "AWS/SNS"
  period              = "300"
  statistic           = "Maximum"
  threshold           = 0.9 * var.sns_monthly_spend_limit_us_west_2
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical-us-west-2.arn]
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-ok-us-west-2.arn]
}

resource "aws_cloudwatch_metric_alarm" "sns-sms-success-rate-canadian-numbers-warning" {
  alarm_name          = "sns-sms-success-rate-canadian-numbers-warning"
  alarm_description   = "SMS success rate to Canadian numbers is below 60% over 2 consecutive periods of 12 hours"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  datapoints_to_alarm = "2"
  metric_name         = "SMSSuccessRate"
  namespace           = "AWS/SNS"
  period              = 60 * 60 * 12
  statistic           = "Average"
  threshold           = 60 / 100
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    SMSType = "Transactional"
    Country = "CA"
  }
}

resource "aws_cloudwatch_metric_alarm" "sns-sms-success-rate-canadian-numbers-us-west-2-warning" {
  provider = aws.us-west-2

  alarm_name          = "sns-sms-success-rate-canadian-numbers-us-west-2-warning"
  alarm_description   = "SMS success rate to Canadian numbers is below 85% over 2 consecutive periods of 12 hours"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  datapoints_to_alarm = "2"
  metric_name         = "SMSSuccessRate"
  namespace           = "AWS/SNS"
  period              = 60 * 60 * 12
  statistic           = "Average"
  threshold           = 85 / 100
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning-us-west-2.arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    SMSType = "Transactional"
    Country = "CA"
  }
}

resource "aws_cloudwatch_metric_alarm" "sns-sms-success-rate-canadian-numbers-critical" {
  alarm_name          = "sns-sms-success-rate-canadian-numbers-critical"
  alarm_description   = "SMS success rate to Canadian numbers is below 25% over 2 consecutive periods of 12 hours"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  datapoints_to_alarm = "2"
  metric_name         = "SMSSuccessRate"
  namespace           = "AWS/SNS"
  period              = 60 * 60 * 12
  statistic           = "Average"
  threshold           = 25 / 100
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    SMSType = "Transactional"
    Country = "CA"
  }
}

resource "aws_cloudwatch_metric_alarm" "sns-sms-success-rate-canadian-numbers-us-west-2-critical" {
  provider = aws.us-west-2

  alarm_name          = "sns-sms-success-rate-canadian-numbers-us-west-2-critical"
  alarm_description   = "SMS success rate to Canadian numbers is below 75% over 2 consecutive periods of 12 hours"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  datapoints_to_alarm = "2"
  metric_name         = "SMSSuccessRate"
  namespace           = "AWS/SNS"
  period              = 60 * 60 * 12
  statistic           = "Average"
  threshold           = 75 / 100
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical-us-west-2.arn]
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-ok-us-west-2.arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    SMSType = "Transactional"
    Country = "CA"
  }
}

resource "aws_cloudwatch_metric_alarm" "sns-sms-blocked-as-spam-warning" {
  alarm_name          = "sns-sms-blocked-as-spam-warning"
  alarm_description   = "More than 10 SMS have been blocked as spam over 12 hours"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.sns-sms-blocked-as-spam.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.sns-sms-blocked-as-spam.metric_transformation[0].namespace
  period              = 60 * 60 * 12
  statistic           = "Sum"
  threshold           = 10
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "sns-sms-blocked-as-spam-us-west-2-warning" {
  provider = aws.us-west-2

  alarm_name          = "sns-sms-blocked-as-spam-us-west-2-warning"
  alarm_description   = "More than 10 SMS have been blocked as spam over 12 hours"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.sns-sms-blocked-as-spam-us-west-2.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.sns-sms-blocked-as-spam-us-west-2.metric_transformation[0].namespace
  period              = 60 * 60 * 12
  statistic           = "Sum"
  threshold           = 10
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning-us-west-2.arn]
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "sns-sms-phone-carrier-unavailable-warning" {
  alarm_name          = "sns-sms-phone-carrier-unavailable-warning"
  alarm_description   = "More than 100 SMS failed because a phone carrier is unavailable over 3 hours"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.sns-sms-phone-carrier-unavailable.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.sns-sms-phone-carrier-unavailable.metric_transformation[0].namespace
  period              = 60 * 60 * 3
  statistic           = "Sum"
  threshold           = 100
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "sns-sms-phone-carrier-unavailable-us-west-2-warning" {
  provider = aws.us-west-2

  alarm_name          = "sns-sms-phone-carrier-unavailable-us-west-2-warning"
  alarm_description   = "More than 100 SMS failed because a phone carrier is unavailable over 3 hours"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.sns-sms-phone-carrier-unavailable-us-west-2.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.sns-sms-phone-carrier-unavailable-us-west-2.metric_transformation[0].namespace
  period              = 60 * 60 * 3
  statistic           = "Sum"
  threshold           = 100
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning-us-west-2.arn]
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "sns-sms-rate-exceeded-warning" {
  alarm_name          = "sns-sms-rate-exceeded-warning"
  alarm_description   = "At least 1 SNS SMS rate exceeded error in 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.sns-sms-rate-exceeded.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.sns-sms-rate-exceeded.metric_transformation[0].namespace
  period              = 60 * 5
  statistic           = "Sum"
  threshold           = 1
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "sns-sms-rate-exceeded-us-west-2-warning" {
  provider = aws.us-west-2

  alarm_name          = "sns-sms-rate-exceeded-us-west-2-warning"
  alarm_description   = "At least 1 SNS SMS rate exceeded error in 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.sns-sms-rate-exceeded-us-west-2.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.sns-sms-rate-exceeded-us-west-2.metric_transformation[0].namespace
  period              = 60 * 5
  statistic           = "Sum"
  threshold           = 1
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning-us-west-2.arn]
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "ses-bounce-rate-warning" {
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

resource "aws_cloudwatch_metric_alarm" "sqs-sms-stuck-in-queue-warning" {
  alarm_name          = "sqs-sms-stuck-in-queue-warning"
  alarm_description   = "ApproximateAgeOfOldestMessage in SMS queue is older than 10 minutes for 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Average"
  threshold           = 60 * 10
  treat_missing_data  = "missing"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_sms_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-sms-stuck-in-queue-critical" {
  alarm_name                = "sqs-sms-stuck-in-queue-critical"
  alarm_description         = "ApproximateAgeOfOldestMessage in SMS queue is older than 15 minutes for 5 minutes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "5"
  metric_name               = "ApproximateAgeOfOldestMessage"
  namespace                 = "AWS/SQS"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 60 * 15
  treat_missing_data        = "missing"
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions                = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_sms_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-send-sms-high-queue-delay-warning" {
  alarm_name          = "sqs-send-sms-high-queue-delay-warning"
  alarm_description   = "ApproximateAgeOfOldestMessage in send sms high priority queue >= 10 seconds for 3 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Average"
  threshold           = 10
  treat_missing_data  = "missing"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_send_sms_high_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-send-sms-high-queue-delay-critical" {
  alarm_name                = "sqs-send-sms-high-queue-delay-critical"
  alarm_description         = "ApproximateAgeOfOldestMessage in send-sms-high queue >= 60 seconds for 5 minutes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "5"
  metric_name               = "ApproximateAgeOfOldestMessage"
  namespace                 = "AWS/SQS"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 60
  datapoints_to_alarm       = 5
  treat_missing_data        = "missing"
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions                = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_send_sms_high_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-send-sms-medium-queue-delay-warning" {
  alarm_name          = "sqs-send-sms-medium-queue-delay-warning"
  alarm_description   = "ApproximateAgeOfOldestMessage in send-sms-medium queue is >= 10 minutes for 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Average"
  threshold           = 60 * 10
  treat_missing_data  = "missing"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_send_sms_medium_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-send-sms-medium-queue-delay-critical" {
  alarm_name                = "sqs-send-sms-medium-queue-delay-critical"
  alarm_description         = "ApproximateAgeOfOldestMessage in send-sms-medium queue is >= 15 minutes for 5 minutes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "5"
  metric_name               = "ApproximateAgeOfOldestMessage"
  namespace                 = "AWS/SQS"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 60 * 15
  treat_missing_data        = "missing"
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions                = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_send_sms_medium_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-send-sms-low-queue-warning" {
  alarm_name          = "sqs-send-sms-low-queue-warning"
  alarm_description   = "ApproximateAgeOfOldestMessage in send-sms-low queue is >= 10 minutes for 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Average"
  threshold           = 60 * 10
  treat_missing_data  = "missing"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_send_sms_low_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-send-sms-low-queue-critical" {
  alarm_name                = "sqs-send-sms-low-queue-critical"
  alarm_description         = "ApproximateAgeOfOldestMessage in send-sms-low queue is >= 3 hours"
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
    QueueName = "${var.celery_queue_prefix}${var.sqs_send_sms_low_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-throttled-sms-stuck-in-queue-warning" {
  alarm_name          = "sqs-throttled-sms-stuck-in-queue-warning"
  alarm_description   = "ApproximateAgeOfOldestMessage in throttled SMS queue >= 5 minutes for 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60 * 5
  statistic           = "Average"
  threshold           = 60 * 5
  treat_missing_data  = "missing"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_throttled_sms_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-throttled-sms-stuck-in-queue-critical" {
  alarm_name                = "sqs-throttled-sms-stuck-in-queue-critical"
  alarm_description         = "ApproximateAgeOfOldestMessage in throttled SMS queue >= 10 minute for 10 minutes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "10"
  metric_name               = "ApproximateAgeOfOldestMessage"
  namespace                 = "AWS/SQS"
  period                    = 60 * 10
  statistic                 = "Average"
  threshold                 = 60 * 10
  treat_missing_data        = "missing"
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions                = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_throttled_sms_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-priority-queue-delay-warning" {
  alarm_name          = "sqs-priority-queue-delay-warning"
  alarm_description   = "ApproximateAgeOfOldestMessage in high priority queue >= 20 seconds for 3 minutes"
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
    QueueName = "${var.celery_queue_prefix}${var.sqs_priority_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-priority-queue-delay-critical" {
  alarm_name                = "sqs-priority-queue-delay-critical"
  alarm_description         = "ApproximateAgeOfOldestMessage in high priority queue >= 60 seconds for 5 minutes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "5"
  metric_name               = "ApproximateAgeOfOldestMessage"
  namespace                 = "AWS/SQS"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 60
  datapoints_to_alarm       = 5
  treat_missing_data        = "missing"
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions                = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_priority_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-email-queue-delay-warning" {
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

resource "aws_cloudwatch_metric_alarm" "sqs-email-queue-delay-critical" {
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

resource "aws_cloudwatch_metric_alarm" "sqs-bulk-queue-delay-warning" {
  alarm_name          = "sqs-bulk-queue-delay-warning"
  alarm_description   = "ApproximateAgeOfOldestMessage in bulk queue reached 60 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Maximum"
  threshold           = 60 * 60
  treat_missing_data  = "missing"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_bulk_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-bulk-queue-delay-critical" {
  alarm_name                = "sqs-bulk-queue-delay-critical"
  alarm_description         = "ApproximateAgeOfOldestMessage in bulk queue reached 3 hours"
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
    QueueName = "${var.celery_queue_prefix}${var.sqs_bulk_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-send-throttled-sms-tasks-receive-rate-warning" {
  alarm_name          = "sqs-send-throttled-sms-tasks-receive-rate-warning"
  alarm_description   = "NumberOfMessagesReceived is more than the expected maximum rate for send-throttled-sms-tasks SQS queue"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "NumberOfMessagesReceived"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Sum"
  # Maximum rate is supposed to be 1 SMS per second, so 60 messages
  # per minute, but giving it a 10% room.
  threshold          = 60 * 1.1
  treat_missing_data = "missing"
  alarm_actions      = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions         = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_throttled_sms_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-send-throttled-sms-tasks-receive-rate-critical" {
  alarm_name          = "sqs-send-throttled-sms-tasks-receive-rate-critical"
  alarm_description   = "NumberOfMessagesReceived is more than the expected maximum rate for send-throttled-sms-tasks SQS queue"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "NumberOfMessagesReceived"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Sum"
  # Maximum rate is supposed to be 1 SMS per second, so 60 messages
  # per minute, but giving it a 30% room for critical.
  # TODO: Review as 30% might be too much.
  threshold                 = 60 * 1.3
  treat_missing_data        = "missing"
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions                = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_throttled_sms_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-db-tasks-stuck-in-queue-warning" {
  alarm_name          = "sqs-db-tasks-stuck-in-queue-warning"
  alarm_description   = "ApproximateAgeOfOldestMessage in DB tasks queue is older than 5 minutes in a 1-minute period"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Maximum"
  threshold           = 60 * 5
  treat_missing_data  = "missing"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_db_tasks_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-db-tasks-stuck-in-queue-critical" {
  alarm_name                = "sqs-db-tasks-stuck-in-queue-critical"
  alarm_description         = "ApproximateAgeOfOldestMessage in DB tasks queue is older than 15 minute for 1 minute"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "15"
  metric_name               = "ApproximateAgeOfOldestMessage"
  namespace                 = "AWS/SQS"
  period                    = 60
  statistic                 = "Maximum"
  threshold                 = 60 * 15
  treat_missing_data        = "missing"
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions                = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_db_tasks_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-priority-db-tasks-stuck-in-queue-warning" {
  alarm_name          = "sqs-priority-db-tasks-stuck-in-queue-warning"
  alarm_description   = "ApproximateAgeOfOldestMessage in priority DB tasks queue is older than 5 minutes in a 1-minute period"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Maximum"
  threshold           = 60 * 5
  treat_missing_data  = "missing"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    QueueName = aws_sqs_queue.priority_db_tasks_queue.name
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-priority-db-tasks-stuck-in-queue-critical" {
  alarm_name                = "sqs-priority-db-tasks-stuck-in-queue-critical"
  alarm_description         = "ApproximateAgeOfOldestMessage in priority DB tasks queue is older than 15 minute for 1 minute"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "15"
  metric_name               = "ApproximateAgeOfOldestMessage"
  namespace                 = "AWS/SQS"
  period                    = 60
  statistic                 = "Maximum"
  threshold                 = 60 * 15
  treat_missing_data        = "missing"
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions                = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
  dimensions = {
    QueueName = aws_sqs_queue.priority_db_tasks_queue.name
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-normal-db-tasks-stuck-in-queue-warning" {
  alarm_name          = "sqs-normal-db-tasks-stuck-in-queue-warning"
  alarm_description   = "ApproximateAgeOfOldestMessage in normal DB tasks queue is older than 5 minutes in a 1-minute period"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Maximum"
  threshold           = 60 * 5
  treat_missing_data  = "missing"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    QueueName = aws_sqs_queue.normal_db_tasks_queue.name
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-normal-db-tasks-stuck-in-queue-critical" {
  alarm_name                = "sqs-normal-db-tasks-stuck-in-queue-critical"
  alarm_description         = "ApproximateAgeOfOldestMessage in normal DB tasks queue is older than 15 minute for 1 minute"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "15"
  metric_name               = "ApproximateAgeOfOldestMessage"
  namespace                 = "AWS/SQS"
  period                    = 60
  statistic                 = "Maximum"
  threshold                 = 60 * 15
  treat_missing_data        = "missing"
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions                = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
  dimensions = {
    QueueName = aws_sqs_queue.normal_db_tasks_queue.name
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-bulk-db-tasks-stuck-in-queue-warning" {
  alarm_name          = "sqs-bulk-db-tasks-stuck-in-queue-warning"
  alarm_description   = "ApproximateAgeOfOldestMessage in bulk DB tasks queue is older than 5 minutes in a 1-minute period"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Maximum"
  threshold           = 60 * 5
  treat_missing_data  = "missing"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    QueueName = aws_sqs_queue.bulk_db_tasks_queue.name
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-bulk-db-tasks-stuck-in-queue-critical" {
  alarm_name                = "sqs-bulk-db-tasks-stuck-in-queue-critical"
  alarm_description         = "ApproximateAgeOfOldestMessage in bulk DB tasks queue is older than 15 minute for 1 minute"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "15"
  metric_name               = "ApproximateAgeOfOldestMessage"
  namespace                 = "AWS/SQS"
  period                    = 60
  statistic                 = "Maximum"
  threshold                 = 60 * 15
  treat_missing_data        = "missing"
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions                = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
  dimensions = {
    QueueName = aws_sqs_queue.bulk_db_tasks_queue.name
  }
}


resource "aws_cloudwatch_metric_alarm" "healtheck-page-slow-response-warning" {
  alarm_name          = "healtheck-page-slow-response-warning"
  alarm_description   = "Healthcheck page response time is above 100ms for 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "${var.env}_notifications_api_GET_status_show_status_200"
  namespace           = "NotificationCanadaCa"
  period              = "300"
  statistic           = "Average"
  threshold           = 100
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  treat_missing_data  = "breaching"
  dimensions = {
    metric_type = "timing"
  }
}

resource "aws_cloudwatch_metric_alarm" "healtheck-page-slow-response-critical" {
  alarm_name                = "healtheck-page-slow-response-critical"
  alarm_description         = "Healthcheck page response time is above 200ms for 10 minutes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "${var.env}_notifications_api_GET_status_show_status_200"
  namespace                 = "NotificationCanadaCa"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = 200
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions                = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
  treat_missing_data        = "breaching"
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

resource "aws_cloudwatch_metric_alarm" "sign-in-3-500-error-15-minutes-critical" {
  alarm_name          = "sign-in-3-500-error-15-minutes-critical"
  alarm_description   = "Three 500 errors in 15 minutes for sign-in"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "${var.env}_notifications_admin_POST_main_sign_in_500"
  namespace           = "NotificationCanadaCa"
  period              = 60 * 15
  statistic           = "Sum"
  threshold           = 3
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
}

resource "aws_cloudwatch_metric_alarm" "contact-3-500-error-15-minutes-critical" {
  alarm_name          = "contact-3-500-error-15-minutes-critical"
  alarm_description   = "Three 500 errors in 15 minutes for contact us"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "${var.env}_notifications_admin_POST_main_contact_500"
  namespace           = "NotificationCanadaCa"
  period              = 60 * 15
  statistic           = "Sum"
  threshold           = 3
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
}

resource "aws_cloudwatch_metric_alarm" "document-download-bucket-size-warning" {
  alarm_name          = "document-download-bucket-size-warning"
  alarm_description   = "Document download S3 bucket size is larger than ${var.alarm_warning_document_download_bucket_size_gb} GB"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "BucketSizeBytes"
  namespace           = "AWS/S3"
  period              = 24 * 60 * 60
  statistic           = "Average"
  threshold           = var.alarm_warning_document_download_bucket_size_gb * 1024 * 1024 * 1024 # Convert the GB variable to bytes
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    StorageType = "StandardStorage"
    BucketName  = aws_s3_bucket.document_bucket.bucket
  }
}

resource "aws_cloudwatch_metric_alarm" "scan-files-document-download-bucket-size-warning" {
  alarm_name          = "scan-files-document-download-bucket-size-warning"
  alarm_description   = "Scan files document download S3 bucket size is larger than ${var.alarm_warning_document_download_bucket_size_gb} GB"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "BucketSizeBytes"
  namespace           = "AWS/S3"
  period              = 24 * 60 * 60
  statistic           = "Average"
  threshold           = var.alarm_warning_document_download_bucket_size_gb * 1024 * 1024 * 1024 # Convert the GB variable to bytes
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    StorageType = "StandardStorage"
    BucketName  = aws_s3_bucket.scan_files_document_bucket.bucket
  }
}

resource "aws_cloudwatch_metric_alarm" "live-service-over-daily-rate-limit-warning" {
  alarm_name          = "live-service-over-daily-rate-limit-warning"
  alarm_description   = "A live service reached its daily rate limit and has been blocked from sending more notifications"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "${var.env}_notifications_api_validators_rate_limit_live_service_daily"
  namespace           = "NotificationCanadaCa"
  period              = "60"
  statistic           = "Sum"
  threshold           = 1
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    metric_type = "counter"
  }
}

resource "aws_cloudwatch_metric_alarm" "inflights-not-being-processed-warning" {
  alarm_name          = "inflights-not-being-processed-warning"
  alarm_description   = "Batch saving inflights are being created but are not being processed fast enough. Difference > ${var.alarm_warning_inflight_processed_created_delta_threshold} for 5 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = var.alarm_warning_inflight_processed_created_delta_threshold
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
        created = "True"
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

resource "aws_cloudwatch_metric_alarm" "inflights-not-being-processed-critical" {
  alarm_name          = "inflights-not-being-processed-critical"
  alarm_description   = "Batch saving inflights are being created but are not being processed fast enough. Difference > ${var.alarm_critical_inflight_processed_created_delta_threshold} for 5 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = var.alarm_critical_inflight_processed_created_delta_threshold
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
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
        created = "True"
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

resource "aws_cloudwatch_metric_alarm" "bulk-not-being-processed-warning" {
  alarm_name          = "bulk-buffer-not-being-processed-warning"
  alarm_description   = "Bulk saving are being created but are not being processed fast enough. Difference > ${var.alarm_warning_bulk_processed_created_delta_threshold} for 5 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = var.alarm_warning_bulk_processed_created_delta_threshold
  treat_missing_data  = "notBreaching"


  alarm_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions    = [aws_sns_topic.notification-canada-ca-alert-ok.arn]

  metric_query {
    id    = "bulk_created"
    label = "Bulk created"

    metric {
      metric_name = "batch_saving_bulk"
      namespace   = "NotificationCanadaCa"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        created = "True"
      }
    }
  }

  metric_query {
    id    = "bulk_processed"
    label = "Bulk processed"

    metric {
      metric_name = "batch_saving_bulk"
      namespace   = "NotificationCanadaCa"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        acknowledged = "True"
      }
    }
  }

  metric_query {
    id          = "delta"
    expression  = "ABS(bulk_created - bulk_processed)"
    label       = "Delta"
    return_data = "true"
  }
}

resource "aws_cloudwatch_metric_alarm" "bulk-not-being-processed-critical" {
  alarm_name          = "bulk-buffer-not-being-processed-critical"
  alarm_description   = "Bulk saving are being created but are not being processed fast enough. Difference > ${var.alarm_critical_bulk_processed_created_delta_threshold} for 5 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = var.alarm_critical_bulk_processed_created_delta_threshold
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions    = [aws_sns_topic.notification-canada-ca-alert-ok.arn]

  metric_query {
    id    = "bulk_created"
    label = "Bulk created"

    metric {
      metric_name = "batch_saving_bulk"
      namespace   = "NotificationCanadaCa"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        created = "True"
      }
    }
  }

  metric_query {
    id    = "bulk_processed"
    label = "Bulk processed"

    metric {
      metric_name = "batch_saving_bulk"
      namespace   = "NotificationCanadaCa"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        acknowledged = "True"
      }
    }
  }

  metric_query {
    id          = "delta"
    expression  = "ABS(bulk_created - bulk_processed)"
    label       = "Delta"
    return_data = "true"
  }
}

resource "aws_cloudwatch_metric_alarm" "priority-bulk-not-being-processed-warning" {
  alarm_name          = "priority-bulk-buffer-not-being-processed-warning"
  alarm_description   = "Priority bulk saving are being created but are not being processed fast enough. Difference > ${var.alarm_warning_bulk_processed_created_delta_threshold} for 5 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = var.alarm_warning_priority_bulk_processed_created_delta_threshold
  treat_missing_data  = "notBreaching"


  alarm_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]

  metric_query {
    id    = "bulk_created"
    label = "Bulk created"

    metric {
      metric_name = "batch_saving_bulk"
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
    id    = "bulk_processed"
    label = "Bulk processed"

    metric {
      metric_name = "batch_saving_bulk"
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
    expression  = "ABS(bulk_created - bulk_processed)"
    label       = "Delta"
    return_data = "true"
  }
}

resource "aws_cloudwatch_metric_alarm" "priority-bulk-not-being-processed-critical" {
  alarm_name          = "priority_bulk-buffer-not-being-processed-critical"
  alarm_description   = "Priority bulk saving are being created but are not being processed fast enough. Difference > ${var.alarm_critical_bulk_processed_created_delta_threshold} for 5 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = var.alarm_critical_priority_bulk_processed_created_delta_threshold
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions    = [aws_sns_topic.notification-canada-ca-alert-ok.arn]

  metric_query {
    id    = "bulk_created"
    label = "Bulk created"

    metric {
      metric_name = "batch_saving_bulk"
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
    id    = "bulk_processed"
    label = "Bulk processed"

    metric {
      metric_name = "batch_saving_bulk"
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
    expression  = "ABS(bulk_created - bulk_processed)"
    label       = "Delta"
    return_data = "true"
  }
}

resource "aws_cloudwatch_metric_alarm" "normal-bulk-not-being-processed-warning" {
  alarm_name          = "normal-bulk-buffer-not-being-processed-warning"
  alarm_description   = "Normal bulk saving are being created but are not being processed fast enough. Difference > ${var.alarm_warning_bulk_processed_created_delta_threshold} for 5 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = var.alarm_warning_normal_bulk_processed_created_delta_threshold
  treat_missing_data  = "notBreaching"


  alarm_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]

  metric_query {
    id    = "bulk_created"
    label = "Bulk created"

    metric {
      metric_name = "batch_saving_bulk"
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
    id    = "bulk_processed"
    label = "Bulk processed"

    metric {
      metric_name = "batch_saving_bulk"
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
    expression  = "ABS(bulk_created - bulk_processed)"
    label       = "Delta"
    return_data = "true"
  }
}

resource "aws_cloudwatch_metric_alarm" "normal-bulk-not-being-processed-critical" {
  alarm_name          = "normal_bulk-buffer-not-being-processed-critical"
  alarm_description   = "Normal bulk saving are being created but are not being processed fast enough. Difference > ${var.alarm_critical_bulk_processed_created_delta_threshold} for 5 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = var.alarm_critical_normal_bulk_processed_created_delta_threshold
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions    = [aws_sns_topic.notification-canada-ca-alert-ok.arn]

  metric_query {
    id    = "bulk_created"
    label = "Bulk created"

    metric {
      metric_name = "batch_saving_bulk"
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
    id    = "bulk_processed"
    label = "Bulk processed"

    metric {
      metric_name = "batch_saving_bulk"
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
    expression  = "ABS(bulk_created - bulk_processed)"
    label       = "Delta"
    return_data = "true"
  }
}

resource "aws_cloudwatch_metric_alarm" "bulk-bulk-not-being-processed-warning" {
  alarm_name          = "bulk-bulk-buffer-not-being-processed-warning"
  alarm_description   = "Bulk bulk saving are being created but are not being processed fast enough. Difference > ${var.alarm_warning_bulk_processed_created_delta_threshold} for 5 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = var.alarm_warning_bulk_bulk_processed_created_delta_threshold
  treat_missing_data  = "notBreaching"


  alarm_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]

  metric_query {
    id    = "bulk_created"
    label = "Bulk created"

    metric {
      metric_name = "batch_saving_bulk"
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
    id    = "bulk_processed"
    label = "Bulk processed"

    metric {
      metric_name = "batch_saving_bulk"
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
    expression  = "ABS(bulk_created - bulk_processed)"
    label       = "Delta"
    return_data = "true"
  }
}

resource "aws_cloudwatch_metric_alarm" "bulk-bulk-not-being-processed-critical" {
  alarm_name          = "bulk_bulk-buffer-not-being-processed-critical"
  alarm_description   = "Bulk bulk saving are being created but are not being processed fast enough. Difference > ${var.alarm_critical_bulk_processed_created_delta_threshold} for 5 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = var.alarm_critical_bulk_bulk_processed_created_delta_threshold
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions    = [aws_sns_topic.notification-canada-ca-alert-ok.arn]

  metric_query {
    id    = "bulk_created"
    label = "Bulk created"

    metric {
      metric_name = "batch_saving_bulk"
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
    id    = "bulk_processed"
    label = "Bulk processed"

    metric {
      metric_name = "batch_saving_bulk"
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
    expression  = "ABS(bulk_created - bulk_processed)"
    label       = "Delta"
    return_data = "true"
  }
}

resource "aws_cloudwatch_metric_alarm" "expired-inflight-warning" {
  alarm_name          = "expired-inflight-warning"
  alarm_description   = "An inflight has expired. Check the Redis-batch-saving dashboard"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  threshold           = 1
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]

  metric_query {
    id          = "expired_inflights_1_minute"
    label       = "Expired inflights in one minute"
    return_data = "true"

    metric {
      metric_name = "batch_saving_inflight"
      namespace   = "NotificationCanadaCa"
      period      = "60"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        expired           = "True"
        notification_type = "any"
        priority          = "any"
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "expired-inflight-critical" {
  alarm_name          = "expired-inflight-critical"
  alarm_description   = "More than ${var.alarm_critical_expired_inflights_threshold} inflights expired in 5 minutes, check the Redis-batch-saving dashboard"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  threshold           = var.alarm_critical_expired_inflights_threshold
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions    = [aws_sns_topic.notification-canada-ca-alert-ok.arn]

  metric_query {
    id          = "expired_inflights_5_minutes"
    label       = "Expired inflights in 5 minutes"
    return_data = "true"

    metric {
      metric_name = "batch_saving_inflight"
      namespace   = "NotificationCanadaCa"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        expired           = "True"
        notification_type = "any"
        priority          = "any"
      }
    }
  }
}
