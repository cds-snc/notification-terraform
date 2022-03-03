terraform {
  source = "../../../aws//common"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  sns_monthly_spend_limit                                   = 30
  sns_monthly_spend_limit_us_west_2                         = 30
  alarm_warning_document_download_bucket_size_gb            = 0.5
  alarm_warning_inflight_processed_created_delta_threshold  = 50
  alarm_critical_inflight_processed_created_delta_threshold = 100
  alarm_warning_bulk_processed_created_delta_threshold      = 50
  alarm_critical_bulk_processed_created_delta_threshold     = 100
}
