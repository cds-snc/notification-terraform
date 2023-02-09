dependencies {
  paths = ["../common"]
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    sns_deliveries_ca_cental          = ""
    sns_deliveries_failures_ca_cental = ""
    sns_deliveries_us_west_2          = ""
    sns_deliveries_failures_us_west_2 = ""
    sns_alert_warning_arn             = ""
    sns_alert_critical_arn            = ""
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  billing_tag_value                       = "notification-canada-ca-staging"
  sns_deliveries_ca_cental                = dependency.common.outputs.sns_deliveries_ca_cental
  sns_deliveries_failures_ca_cental       = dependency.common.outputs.sns_deliveries_failures_ca_cental
  sns_deliveries_us_west_2                = dependency.common.outputs.sns_deliveries_us_west_2
  sns_deliveries_failures_us_west_2       = dependency.common.outputs.sns_deliveries_failures_us_west_2
  sns_alert_warning_arn                   = dependency.common.outputs.sns_alert_warning_arn
  sns_alert_critical_arn                  = dependency.common.outputs.sns_alert_critical_arn
}

terraform {
  source = "../../../aws//sns_to_sqs_sms_callbacks"
}
