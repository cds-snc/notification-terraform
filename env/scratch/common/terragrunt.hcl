terraform {
  source = "../../../aws//common"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  sns_monthly_spend_limit                                            = 1
  sns_monthly_spend_limit_us_west_2                                  = 1
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
  alarm_critical_expired_inflights_threshold                         = 10
  billing_tag_value                                                  = "notification-canada-ca-scratch"
  sqs_visibility_timeout_default                                     = 305
  sqs_visibility_timeout_priority_high                               = 305
  sqs_priority_db_tasks_queue_name                                   = "priority-database-tasks.fifo"
  sqs_normal_db_tasks_queue_name                                     = "normal-database-tasks"
  sqs_bulk_db_tasks_queue_name                                       = "bulk-database-tasks"
  eks_cluster_name                                                   = "notification-canada-ca-scratch-eks-cluster"
}

# See QueueNames in
# https://github.com/cds-snc/notification-api/blob/master/app/config.py
