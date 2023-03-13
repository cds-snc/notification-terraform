dependencies {
  paths = ["../common"]
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs = {
    sns_alert_warning_arn  = ""
    sns_alert_critical_arn = ""
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  billing_tag_value      = "notification-canada-ca-staging"
  schedule_expression    = "rate(1 minute)"
  sns_alert_warning_arn  = dependency.common.outputs.sns_alert_warning_arn
  sns_alert_critical_arn = dependency.common.outputs.sns_alert_critical_arn
}

terraform {
  source = "../../../aws//heartbeat"
}
