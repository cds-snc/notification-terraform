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
    sns_alert_warning_arn                        = ""
    sns_alert_critical_arn                       = ""
    sns_alert_ok_arn                             = ""
    sqs_deliver_receipts_queue_arn               = ""

  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  billing_tag_value                                = "notification-canada-ca-staging"
  sns_alert_warning_arn                            = dependency.common.outputs.sns_alert_warning_arn
  sns_alert_critical_arn                           = dependency.common.outputs.sns_alert_critical_arn
  sns_alert_ok_arn                                 = dependency.common.outputs.sns_alert_ok_arn
  sqs_deliver_receipts_queue_arn                   = dependency.common.outputs.sqs_deliver_receipts_queue_arn
}

terraform {
  source = "../../../aws//pinpoint_to_sqs_sms_callbacks"
}
