terraform {
  source = "../../../aws//common"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  sns_monthly_spend_limit                                            = 50
  sns_monthly_spend_limit_us_west_2                                  = 30
  alarm_warning_document_download_bucket_size_gb                     = 0.5
  alarm_warning_inflight_processed_created_delta_threshold           = 100
  alarm_critical_inflight_processed_created_delta_threshold          = 200
  alarm_warning_priority_inflight_processed_created_delta_threshold  = 100
  alarm_critical_priority_inflight_processed_created_delta_threshold = 300
  alarm_warning_normal_inflight_processed_created_delta_threshold    = 100
  alarm_critical_normal_inflight_processed_created_delta_threshold   = 200
  alarm_warning_bulk_inflight_processed_created_delta_threshold      = 100
  alarm_critical_bulk_inflight_processed_created_delta_threshold     = 200
  alarm_warning_bulk_processed_created_delta_threshold               = 5000
  alarm_critical_bulk_processed_created_delta_threshold              = 10000
  alarm_warning_priority_bulk_processed_created_delta_threshold      = 5000
  alarm_critical_priority_bulk_processed_created_delta_threshold     = 10000
  alarm_warning_normal_bulk_processed_created_delta_threshold        = 5000
  alarm_critical_normal_bulk_processed_created_delta_threshold       = 10000
  alarm_warning_bulk_bulk_processed_created_delta_threshold          = 5000
  alarm_critical_bulk_bulk_processed_created_delta_threshold         = 10000
  alarm_warning_expired_sms_created_threshold                        = 100
  alarm_critical_expired_sms_created_threshold                       = 200
  alarm_warning_expired_email_created_threshold                      = 100
  alarm_critical_expired_email_created_threshold                     = 200
  billing_tag_value                                                  = "notification-canada-ca-staging"
  sqs_priority_db_tasks_queue_name                                   = "priority-database-tasks.fifo"
  sqs_normal_db_tasks_queue_name                                     = "normal-database-tasks"
  sqs_bulk_db_tasks_queue_name                                       = "bulk-database-tasks"
}

# See QueueNames in
# https://github.com/cds-snc/notification-api/blob/master/app/config.py
