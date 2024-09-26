dependencies {
  paths = ["../common", "../dns"]
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    notification_canada_ca_ses_callback_arn = ""
  }
}

dependency "dns" {
  config_path = "../dns"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    lambda_ses_receiving_emails_image_arn = ""
    notification_canada_ca_receiving_dkim = []
    notification_canada_ca_dkim = []
    cic_trvapply_vrtdemande_dkim = []
    custom_sending_domains_dkim = []
    route53_zone_id = "Z04028033PLSHVOO9ZJ1Z"
  }
}


include {
  path = find_in_parent_folders()
}

inputs = {
  custom_sending_domains_dkim   = dependency.dns.outputs.custom_sending_domains_dkim
  cic_trvapply_vrtdemande_dkim  = dependency.dns.outputs.cic_trvapply_vrtdemande_dkim
  notification_canada_ca_dkim   = dependency.dns.outputs.notification_canada_ca_dkim
  notification_canada_ca_receiving_dkim   = dependency.dns.outputs.notification_canada_ca_receiving_dkim
  route53_zone_id                        = dependency.dns.outputs.route53_zone_id
}

terraform {
  source = "../../../aws//ses_validation_dns_entries"

}
