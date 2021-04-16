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
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
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
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical-us-west-2.arn]
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-critical-us-west-2.arn]
}

resource "aws_cloudwatch_metric_alarm" "sns-sms-success-rate-canadian-numbers-warning" {
  alarm_name          = "sns-sms-success-rate-canadian-numbers-warning"
  alarm_description   = "SMS success rate to Canadian numbers is below 85% over 2 consecutive periods of 12 hours"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  datapoints_to_alarm = "2"
  metric_name         = "SMSSuccessRate"
  namespace           = "AWS/SNS"
  period              = 60 * 60 * 12
  statistic           = "Average"
  threshold           = 85 / 100
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
  alarm_description   = "SMS success rate to Canadian numbers is below 75% over 2 consecutive periods of 12 hours"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  datapoints_to_alarm = "2"
  metric_name         = "SMSSuccessRate"
  namespace           = "AWS/SNS"
  period              = 60 * 60 * 12
  statistic           = "Average"
  threshold           = 75 / 100
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
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
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-critical-us-west-2.arn]
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
  alarm_description   = "More than 10 SMS failed because a phone carrier is unavailable over 6 hours"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.sns-sms-phone-carrier-unavailable.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.sns-sms-phone-carrier-unavailable.metric_transformation[0].namespace
  period              = 60 * 60 * 6
  statistic           = "Sum"
  threshold           = 10
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "sns-sms-phone-carrier-unavailable-us-west-2-warning" {
  provider = aws.us-west-2

  alarm_name          = "sns-sms-phone-carrier-unavailable-us-west-2-warning"
  alarm_description   = "More than 10 SMS failed because a phone carrier is unavailable over 6 hours"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.sns-sms-phone-carrier-unavailable-us-west-2.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.sns-sms-phone-carrier-unavailable-us-west-2.metric_transformation[0].namespace
  period              = 60 * 60 * 6
  statistic           = "Sum"
  threshold           = 10
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning-us-west-2.arn]
  treat_missing_data  = "notBreaching"
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
  alarm_description   = "ApproximateAgeOfOldestMessage in SMS queue is older than 1 minute in a 5-minute period"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60 * 5
  statistic           = "Average"
  threshold           = 60
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_sms_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-sms-stuck-in-queue-critical" {
  alarm_name          = "sqs-sms-stuck-in-queue-critical"
  alarm_description   = "ApproximateAgeOfOldestMessage in SMS queue is older than 1 minute for 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60 * 5
  statistic           = "Average"
  threshold           = 60
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_sms_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-throttled-sms-stuck-in-queue-warning" {
  alarm_name          = "sqs-throttled-sms-stuck-in-queue-warning"
  alarm_description   = "ApproximateAgeOfOldestMessage in throttled SMS queue is older than 1 minute in a 5-minute period"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60 * 5
  statistic           = "Average"
  threshold           = 60
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_throttled_sms_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-throttled-sms-stuck-in-queue-critical" {
  alarm_name          = "sqs-throttled-sms-stuck-in-queue-critical"
  alarm_description   = "ApproximateAgeOfOldestMessage in throttled SMS queue is older than 1 minute for 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60 * 5
  statistic           = "Average"
  threshold           = 60
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}${var.sqs_throttled_sms_queue_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-email-stuck-in-queue-warning" {
  alarm_name          = "sqs-email-stuck-in-queue-warning"
  alarm_description   = "ApproximateAgeOfOldestMessage in email queue reached 60 seconds"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Maximum"
  threshold           = 60
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}send-email-tasks"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-email-stuck-in-queue-critical" {
  alarm_name          = "sqs-email-stuck-in-queue-critical"
  alarm_description   = "ApproximateAgeOfOldestMessage in email queue reached 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Maximum"
  threshold           = 60 * 10
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}send-email-tasks"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-bulk-queue-delay-warning" {
  alarm_name          = "sqs-bulk-queue-delay-warning"
  alarm_description   = "ApproximateAgeOfOldestMessage in bulk queue reached 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Maximum"
  threshold           = 60 * 10
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}bulk-tasks"
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-bulk-queue-delay-critical" {
  alarm_name          = "sqs-bulk-queue-delay-critical"
  alarm_description   = "ApproximateAgeOfOldestMessage in bulk queue reached 30 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Maximum"
  threshold           = 60 * 30
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  dimensions = {
    QueueName = "${var.celery_queue_prefix}bulk-tasks"
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

resource "aws_cloudwatch_metric_alarm" "lambda-ses-delivery-receipts-errors-warning" {
  alarm_name          = "lambda-ses-delivery-receipts-errors-warning"
  alarm_description   = "5 errors on Lambda ses-to-sqs-email-callbacks in 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60 * 10
  statistic           = "Sum"
  threshold           = 5
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    FunctionName = aws_lambda_function.ses_to_sqs_email_callbacks.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda-sns-delivery-receipts-errors-warning" {
  alarm_name          = "lambda-sns-delivery-receipts-errors-warning"
  alarm_description   = "5 errors on Lambda sns-to-sqs-sms-callbacks in 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60 * 10
  statistic           = "Sum"
  threshold           = 5
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    FunctionName = aws_lambda_function.sns_to_sqs_sms_callbacks.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "sign-in-3-500-error-15-minutes-critical" {
  alarm_name          = "sign-in-3-500-error-15-minutes-critical"
  alarm_description   = "Three 500 errors in 15 minutes for sign-in"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "production_notifications_admin_POST_main_sign_in_500"
  namespace           = "NotificationCanadaCa"
  period              = 60 * 15
  statistic           = "Sum"
  threshold           = 3
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
}

resource "aws_cloudwatch_metric_alarm" "contact-3-500-error-15-minutes-critical" {
  alarm_name          = "contact-3-500-error-15-minutes-critical"
  alarm_description   = "Three 500 errors in 15 minutes for contact us"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "production_notifications_admin_POST_main_contact_500"
  namespace           = "NotificationCanadaCa"
  period              = 60 * 15
  statistic           = "Sum"
  threshold           = 3
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
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
