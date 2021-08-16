terraform {
  source = "../../../aws//common"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  sns_monthly_spend_limit                        = 30
  sns_monthly_spend_limit_us_west_2              = 1
  alarm_warning_document_download_bucket_size_gb = 0.5
}
