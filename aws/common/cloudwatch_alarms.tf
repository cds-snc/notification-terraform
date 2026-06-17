# Note to maintainers:
# Updating alarms? Update the Google Sheet also!
# https://docs.google.com/spreadsheets/d/1gkrL3Trxw0xEkX724C1bwpfeRsTlK2X60wtCjF6MFRA/edit
#
# There are also alarms defined in aws/eks/cloudwatch_alarms.tf

resource "aws_cloudwatch_metric_alarm" "sqs-priority-queue-delay-warning" {
  provider            = aws.core_services
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
  provider                  = aws.core_services
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
  provider            = aws.core_services
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
  provider                  = aws.core_services
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

resource "aws_cloudwatch_metric_alarm" "sqs-db-tasks-stuck-in-queue-warning" {
  for_each            = var.cloudwatch_enabled ? { for q in local.sqs_database_queue_configs : q.name => q } : {}
  provider            = aws.core_services
  alarm_name          = "sqs-${each.key}-db-tasks-stuck-in-queue-warning"
  alarm_description   = "ApproximateAgeOfOldestMessage in ${each.key} DB tasks queue is older than ${each.value.warning_age_seconds / 60} minutes (priority=${each.value.priority})"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Maximum"
  threshold           = each.value.warning_age_seconds
  treat_missing_data  = "missing"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  dimensions = {
    QueueName = each.value.queue_ref
  }
}

resource "aws_cloudwatch_metric_alarm" "sqs-db-tasks-stuck-in-queue-critical" {
  for_each                  = var.cloudwatch_enabled ? { for q in local.sqs_database_queue_configs : q.name => q } : {}
  provider                  = aws.core_services
  alarm_name                = "sqs-${each.key}-db-tasks-stuck-in-queue-critical"
  alarm_description         = "ApproximateAgeOfOldestMessage in ${each.key} DB tasks queue is older than ${each.value.critical_age_seconds / 60} minutes for 1 minute (priority=${each.value.priority})"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "ApproximateAgeOfOldestMessage"
  namespace                 = "AWS/SQS"
  period                    = 60
  statistic                 = "Maximum"
  threshold                 = each.value.critical_age_seconds
  treat_missing_data        = "missing"
  alarm_actions             = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  insufficient_data_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions                = [aws_sns_topic.notification-canada-ca-alert-ok.arn]
  dimensions = {
    QueueName = each.value.queue_ref
  }
}






resource "aws_cloudwatch_metric_alarm" "healtheck-page-slow-response-warning" {
  provider            = aws.core_services
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
  provider                  = aws.core_services
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
  provider            = aws.core_services
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
  provider            = aws.core_services
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
  provider            = aws.core_services
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
  provider            = aws.core_services
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
  provider            = aws.core_services
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
  provider            = aws.core_services
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
  provider            = aws.core_services
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
  provider            = aws.core_services
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
  provider            = aws.core_services
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
  provider            = aws.core_services
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
  provider            = aws.core_services
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
  provider            = aws.core_services
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
  provider            = aws.core_services
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
  provider            = aws.core_services
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
  provider            = aws.core_services
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

resource "aws_cloudwatch_metric_alarm" "expired-inflight-poisoned-message-warning" {
  provider            = aws.core_services
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "expired-inflight-any"
  alarm_description   = "Possible poisoned message - inflights are expiring. Investigate if this is repeated. Check the Redis-batch-saving dashboard"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  threshold           = 1
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]

  metric_name = "batch_saving_inflight"
  namespace   = "NotificationCanadaCa"
  period      = "300"
  statistic   = "Sum"
  unit        = "Count"
  dimensions = {
    expired           = "True"
    notification_type = "any"
    priority          = "any"
  }
}

resource "aws_cloudwatch_metric_alarm" "expired-inflight-queue-warning" {
  for_each = var.cloudwatch_enabled ? { for q in local.inflight_queue_configs : q.name => q } : {}
  provider = aws.core_services

  alarm_name          = "expired-inflight-${each.key}-warning"
  alarm_description   = "Inflights are expiring (>${each.value.warning_expiry_count} in 5min) on the ${each.key} queue (priority=${each.value.priority}, max_expiry=${each.value.max_expiry_minutes}min) - queue is deteriorating. Check the Redis-batch-saving dashboard"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  threshold           = each.value.warning_expiry_count
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.notification-canada-ca-alert-warning.arn]

  metric_query {
    id    = "expired_inflights"
    label = "Expired inflights in 5 minutes"

    metric {
      metric_name = "batch_saving_inflight"
      namespace   = "NotificationCanadaCa"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        expired           = "True"
        notification_type = each.value.notification_type
        priority          = each.value.priority
      }
    }
  }

  metric_query {
    id          = "alarm_condition"
    expression  = "expired_inflights"
    label       = "Expiry count"
    return_data = "true"
  }
}

locals {
  # Inflight queue configurations with priority-specific expiry thresholds
  # max_expiry_minutes: how long a message can sit in inflight before being auto-returned to inbox
  # warning_expiry_count: alarm if this many messages expire in 5 minutes (indicates queue deteriorating)
  # critical_expiry_count: alarm if this many messages expire in 5 minutes (indicates queue stuck)
  inflight_queue_configs = [
    { name = "email-bulk", notification_type = "email", priority = "bulk", max_expiry_minutes = 45, warning_expiry_count = 50, critical_expiry_count = 100 },
    { name = "email-normal", notification_type = "email", priority = "normal", max_expiry_minutes = 30, warning_expiry_count = 20, critical_expiry_count = 50 },
    { name = "email-priority", notification_type = "email", priority = "priority", max_expiry_minutes = 5, warning_expiry_count = 5, critical_expiry_count = 10 },
    { name = "sms-bulk", notification_type = "sms", priority = "bulk", max_expiry_minutes = 45, warning_expiry_count = 50, critical_expiry_count = 100 },
    { name = "sms-normal", notification_type = "sms", priority = "normal", max_expiry_minutes = 30, warning_expiry_count = 20, critical_expiry_count = 50 },
    { name = "sms-priority", notification_type = "sms", priority = "priority", max_expiry_minutes = 5, warning_expiry_count = 5, critical_expiry_count = 10 },
  ]

  # SQS database queue configurations with priority-specific age thresholds
  # warning_age_seconds: alarm if oldest message in queue exceeds this age
  # critical_age_seconds: alarm if oldest message in queue exceeds this age
  # Aligned with inflight max_expiry_minutes for consistent queue lifecycle expectations
  sqs_database_queue_configs = [
    { name = "email-bulk", queue_ref = aws_sqs_queue.bulk_db_tasks_queue.name, priority = "bulk", warning_age_seconds = 1800, critical_age_seconds = 2700 },
    { name = "email-normal", queue_ref = aws_sqs_queue.normal_db_tasks_queue.name, priority = "normal", warning_age_seconds = 1200, critical_age_seconds = 1800 },
    { name = "email-priority", queue_ref = aws_sqs_queue.priority_db_tasks_queue.name, priority = "priority", warning_age_seconds = 180, critical_age_seconds = 300 },
  ]
}

resource "aws_cloudwatch_metric_alarm" "expired-inflight-queue-critical" {
  for_each = var.cloudwatch_enabled ? { for q in local.inflight_queue_configs : q.name => q } : {}
  provider = aws.core_services

  alarm_name          = "expired-inflight-${each.key}-critical"
  alarm_description   = "More than ${each.value.critical_expiry_count} inflights expired in 5 minutes on ${each.key} (priority=${each.value.priority}, max_expiry=${each.value.max_expiry_minutes}min) AND celery acknowledgment throughput is zero - inflight queue is stuck. Check the Redis-batch-saving dashboard."
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  threshold           = 1
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.notification-canada-ca-alert-critical.arn]
  ok_actions    = [aws_sns_topic.notification-canada-ca-alert-ok.arn]

  metric_query {
    id    = "expired_inflights"
    label = "Expired inflights in 5 minutes"

    metric {
      metric_name = "batch_saving_inflight"
      namespace   = "NotificationCanadaCa"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        expired           = "True"
        notification_type = each.value.notification_type
        priority          = each.value.priority
      }
    }
  }

  metric_query {
    id    = "inflight_processed"
    label = "Inflights acknowledged in 5 minutes"

    metric {
      metric_name = "batch_saving_inflight"
      namespace   = "NotificationCanadaCa"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        acknowledged      = "True"
        notification_type = each.value.notification_type
        priority          = each.value.priority
      }
    }
  }

  metric_query {
    id          = "alarm_condition"
    expression  = "IF(expired_inflights >= ${each.value.critical_expiry_count}, 1, 0) * IF(FILL(inflight_processed, 0) < 1, 1, 0)"
    label       = "Expiries over threshold AND zero acks"
    return_data = "true"
  }
}

