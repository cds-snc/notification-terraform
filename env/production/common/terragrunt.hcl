# Uses GitHub tags for release management
#
terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/common?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  sns_monthly_spend_limit                        = 10000
  sns_monthly_spend_limit_us_west_2              = 2000
  alarm_warning_document_download_bucket_size_gb = 100
}
