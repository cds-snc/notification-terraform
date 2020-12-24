# Uses GitHub tags for release management
#
terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/common?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  sns_monthly_spend_limit  = 10000
}
