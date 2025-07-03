# Note to maintainers:
# Updating alarms? Update the Google Sheet also!
# https://docs.google.com/spreadsheets/d/1gkrL3Trxw0xEkX724C1bwpfeRsTlK2X60wtCjF6MFRA/edit
#
# There are also alarms defined in aws/eks/cloudwatch_alarms.tf

resource "aws_cloudwatch_metric_alarm" "coredns-nxdomain-notification-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "coredns-nxdomain-notification-warning"
  alarm_description   = "More than 30 NXDOMAIN responses containing 'notification' in CoreDNS logs in 5 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CoreDNSNXDOMAINNotificationCount"
  namespace           = "NotificationCanadaCa/DNS"
  period              = 300 # 5 minutes
  statistic           = "Sum"
  threshold           = 30
  alarm_actions       = []
  ok_actions          = []
  # alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  # ok_actions          = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
  treat_missing_data = "notBreaching"
}

# CloudWatch Alarm for Route53 DNS resolution failures (Warning)
resource "aws_cloudwatch_metric_alarm" "route53-dns-failures-warning" {
  provider                  = aws.us-east-1
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "route53-dns-resolution-failures-warning"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 3
  metric_name               = "Route53PublicDNSResolutionFailureCount"
  namespace                 = "Route53/PublicResolver"
  period                    = 300 # 5 minutes
  statistic                 = "Sum"
  threshold                 = 5
  alarm_description         = "Alarm for Route53 DNS resolution failures exceeding threshold"
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-warning-us-east-1.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning-us-east-1.arn]
  ok_actions                = [aws_sns_topic.notification-canada-ca-alert-ok-us-east-1.arn]
  treat_missing_data        = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "sqs-priority-queue-delay-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count                     = var.cloudwatch_enabled ? 1 : 0
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

resource "aws_cloudwatch_metric_alarm" "sqs-bulk-queue-delay-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count                     = var.cloudwatch_enabled ? 1 : 0
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

resource "aws_cloudwatch_metric_alarm" "sqs-priority-db-tasks-stuck-in-queue-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count                     = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count                     = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count                     = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count                     = var.cloudwatch_enabled ? 1 : 0
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

resource "aws_cloudwatch_metric_alarm" "sign-in-3-500-error-15-minutes-critical" {
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
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
