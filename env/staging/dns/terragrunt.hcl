dependencies {
  paths = ["../common"]
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    notification_canada_ca_ses_callback_arn = ""
    lambda_ses_receiving_emails_arn         = ""
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  notification_canada_ca_ses_callback_arn = dependency.common.outputs.notification_canada_ca_ses_callback_arn
  lambda_ses_receiving_emails_arn         = dependency.common.outputs.lambda_ses_receiving_emails_arn
  custom_sending_domains                  = ["notification.gov.bc.ca", "test.example.com"]
}

terraform {
  source = "../../../aws//dns"
}

