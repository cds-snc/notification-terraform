include {
  path = find_in_parent_folders()
}

inputs = {
  env                                    = "staging"
  billing_tag_value                      = "notification-canada-ca-staging"
}

terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/system_status?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}