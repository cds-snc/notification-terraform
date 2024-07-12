dependencies {
  paths = ["../common", "../ses_receiving_emails"]
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "destroy"]
  mock_outputs = {
    notification_canada_ca_ses_callback_arn = ""
  }
}

dependency "ses_receiving_emails" {
  config_path = "../ses_receiving_emails"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show", "destroy"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    lambda_ses_receiving_emails_image_arn = ""
  }
}


include {
  path = find_in_parent_folders()
}

inputs = {
  notification_canada_ca_ses_callback_arn = dependency.common.outputs.notification_canada_ca_ses_callback_arn
  vpc_id                                  = dependency.common.outputs.vpc_id
  lambda_ses_receiving_emails_image_arn   = dependency.ses_receiving_emails.outputs.lambda_ses_receiving_emails_image_arn
}

terraform {
  source = "../../aws//dns"

}

