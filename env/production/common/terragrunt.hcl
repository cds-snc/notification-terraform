# Uses GitHub tags for release management
#
terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/common?ref=v0.20.0"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  sns_monthly_spend_limit = 10000
}
