# Uses GitHub tags for release management
#
terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/common?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  sns_monthly_spend_limit                                   = 30000
  sns_monthly_spend_limit_us_west_2                         = 2000
  alarm_warning_document_download_bucket_size_gb            = 100
  alarm_warning_inflight_processed_created_delta_threshold  = 100
  alarm_critical_inflight_processed_created_delta_threshold = 200
  alarm_warning_bulk_processed_created_delta_threshold      = 5000
  alarm_critical_bulk_processed_created_delta_threshold     = 10000
  sqs_priority_db_tasks_queue_name                          = "priority-database-tasks.fifo"
  sqs_normal_db_tasks_queue_name                            = "normal-database-tasks"
  sqs_bulk_db_tasks_queue_name                              = "bulk-database-tasks"
}

# See QueueNames in
# https://github.com/cds-snc/notification-api/blob/master/app/config.py
