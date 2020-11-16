terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/common?ref=v0.13.2"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  sns_monthly_spend_limit = 1
}
