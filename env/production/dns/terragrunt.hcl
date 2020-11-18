terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/dns?ref=v0.22.0"
}

dependencies {
  paths = ["../common"]
}

dependency "common" {
  config_path = "../common"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  notification_canada_ca_ses_callback_arn = dependency.common.outputs.notification_canada_ca_ses_callback_arn
}
