# Uses GitHub tags for release management
terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/dns?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
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
  lambda_ses_receiving_emails_arn         = dependency.common.outputs.lambda_ses_receiving_emails_arn
  ses_custom_sending_domains              = ["notification.gov.bc.ca"]
}
