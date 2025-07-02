# Note to maintainers:
# Updating alarms? Update the Google Sheet also!
# https://docs.google.com/spreadsheets/d/1gkrL3Trxw0xEkX724C1bwpfeRsTlK2X60wtCjF6MFRA/edit
#
# There are also alarms defined in aws/eks/cloudwatch_alarms.tf


resource "aws_cloudwatch_metric_alarm" "sns-spending-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
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

  count               = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
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

  count               = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count    = var.cloudwatch_enabled ? 1 : 0

  alarm_name          = "sns-sms-success-rate-canadian-numbers-us-west-2-warning"
  alarm_description   = "SMS success rate to Canadian numbers is below 85% over 2 consecutive periods of 12 hours"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  datapoints_to_alarm = "2"
  threshold           = "1"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning-us-west-2.arn]
  treat_missing_data  = "notBreaching"

  metric_query {
    id          = "successRate"
    label       = "Success Rate"
    return_data = false
    metric {
      namespace   = "AWS/SNS"
      metric_name = "SMSSuccessRate"
      period      = 60 * 60 * 12
      stat        = "Average"
      dimensions = {
        SMSType = "Transactional"
        Country = "CA"
      }
    }
  }

  metric_query {
    id          = "messagesPublished"
    label       = "Messages Published"
    return_data = false
    metric {
      namespace   = "AWS/SNS"
      metric_name = "NumberOfMessagesPublished"
      period      = 60 * 60 * 12
      stat        = "Sum"
      dimensions = {
        SMSType = "Transactional"
        Country = "CA"
      }
    }
  }

  metric_query {
    id          = "alarmCondition"
    label       = "Guarded Alarm Condition"
    return_data = true
    expression  = "IF(successRate < 0.85 AND messagesPublished > 75, 0, 1)"
  }
}

resource "aws_cloudwatch_metric_alarm" "sns-sms-success-rate-canadian-numbers-critical" {
  count               = var.cloudwatch_enabled ? 1 : 0
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

  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "sns-sms-success-rate-canadian-numbers-us-west-2-critical"
  alarm_description   = "SMS success rate to Canadian numbers is below 50% over 4 consecutive periods of 6 hrs"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "4"
  datapoints_to_alarm = "4"
  metric_name         = "SMSSuccessRate"
  namespace           = "AWS/SNS"
  period              = 60 * 60 * 6
  statistic           = "Average"
  threshold           = 50 / 100
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical-us-west-2.arn]
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-ok-us-west-2.arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    SMSType = "Transactional"
    Country = "CA"
  }
}

resource "aws_cloudwatch_metric_alarm" "sns-sms-blocked-as-spam-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "sns-sms-blocked-as-spam-warning"
  alarm_description   = "More than 10 SMS have been blocked as spam over 12 hours"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.sns-sms-blocked-as-spam[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.sns-sms-blocked-as-spam[0].metric_transformation[0].namespace
  period              = 60 * 60 * 12
  statistic           = "Sum"
  threshold           = 10
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "sns-sms-blocked-as-spam-us-west-2-warning" {
  provider = aws.us-west-2

  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "sns-sms-blocked-as-spam-us-west-2-warning"
  alarm_description   = "More than 10 SMS have been blocked as spam over 12 hours"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.sns-sms-blocked-as-spam-us-west-2[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.sns-sms-blocked-as-spam-us-west-2[0].metric_transformation[0].namespace
  period              = 60 * 60 * 12
  statistic           = "Sum"
  threshold           = 10
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning-us-west-2.arn]
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "sns-sms-phone-carrier-unavailable-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "sns-sms-phone-carrier-unavailable-warning"
  alarm_description   = "More than 100 SMS failed because a phone carrier is unavailable over 3 hours"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.sns-sms-phone-carrier-unavailable[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.sns-sms-phone-carrier-unavailable[0].metric_transformation[0].namespace
  period              = 60 * 60 * 3
  statistic           = "Sum"
  threshold           = 100
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "sns-sms-phone-carrier-unavailable-us-west-2-warning" {
  provider = aws.us-west-2

  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "sns-sms-phone-carrier-unavailable-us-west-2-warning"
  alarm_description   = "More than 100 SMS failed because a phone carrier is unavailable over 3 hours"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.sns-sms-phone-carrier-unavailable-us-west-2[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.sns-sms-phone-carrier-unavailable-us-west-2[0].metric_transformation[0].namespace
  period              = 60 * 60 * 3
  statistic           = "Sum"
  threshold           = 100
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning-us-west-2.arn]
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "sns-sms-rate-exceeded-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "sns-sms-rate-exceeded-warning"
  alarm_description   = "At least 1 SNS SMS rate exceeded error in 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.sns-sms-rate-exceeded[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.sns-sms-rate-exceeded[0].metric_transformation[0].namespace
  period              = 60 * 5
  statistic           = "Sum"
  threshold           = 1
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "sns-sms-rate-exceeded-us-west-2-warning" {
  provider = aws.us-west-2

  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "sns-sms-rate-exceeded-us-west-2-warning"
  alarm_description   = "At least 1 SNS SMS rate exceeded error in 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.sns-sms-rate-exceeded-us-west-2[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.sns-sms-rate-exceeded-us-west-2[0].metric_transformation[0].namespace
  period              = 60 * 5
  statistic           = "Sum"
  threshold           = 1
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning-us-west-2.arn]
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "sqs-send-sms-high-queue-delay-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "sqs-send-sms-high-queue-delay-critical"
  alarm_description         = "ApproximateAgeOfOldestMessage in send-sms-high queue >= 60 seconds for 5 minutes"
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
    QueueName = "${var.celery_queue_prefix}${var.sqs_send_sms_high_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-send-sms-medium-queue-delay-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count                     = var.cloudwatch_enabled ? 1 : 0
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

resource "aws_cloudwatch_metric_alarm" "sqs-send-sms-low-queue-delay-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "sqs-send-sms-low-queue-delay-warning"
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

resource "aws_cloudwatch_metric_alarm" "sqs-send-sms-low-queue-delay-critical" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "sqs-send-sms-low-queue-delay-critical"
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
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "sqs-throttled-sms-stuck-in-queue-warning"
  alarm_description   = "Delay in throttled SMS queue >= 45 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Average"
  threshold           = 60 * 45
  treat_missing_data  = "missing"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_throttled_sms_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-throttled-sms-stuck-in-queue-critical" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "sqs-throttled-sms-stuck-in-queue-critical"
  alarm_description         = "Delay in throttled SMS queue >= 60 minute"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "ApproximateAgeOfOldestMessage"
  namespace                 = "AWS/SQS"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 60 * 60
  treat_missing_data        = "missing"
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions                = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_throttled_sms_queue_name}"
  }
}


resource "aws_cloudwatch_metric_alarm" "sqs-send-throttled-sms-tasks-receive-rate-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
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
