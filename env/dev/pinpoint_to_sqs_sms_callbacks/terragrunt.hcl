dependencies {
  paths = ["../common", "../ecr"]
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show", "destroy"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    sns_alert_warning_arn                        = ""
    sns_alert_critical_arn                       = ""
    sns_alert_ok_arn                             = ""
    sqs_deliver_receipts_queue_arn               = ""
  }
}

dependency "ecr" {
  config_path = "../ecr"
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show", "destroy"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    pinpoint_to_sqs_sms_callbacks_ecr_repository_url = ""
    pinpoint_to_sqs_sms_callbacks_ecr_arn            = ""
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  billing_tag_value                                  = "notification-canada-ca-dev"
  sns_alert_warning_arn                              = dependency.common.outputs.sns_alert_warning_arn
  sns_alert_critical_arn                             = dependency.common.outputs.sns_alert_critical_arn
  sns_alert_ok_arn                                   = dependency.common.outputs.sns_alert_ok_arn
  sqs_deliver_receipts_queue_arn                     = dependency.common.outputs.sqs_deliver_receipts_queue_arn
  pinpoint_to_sqs_sms_callbacks_ecr_repository_url   = dependency.ecr.outputs.pinpoint_to_sqs_sms_callbacks_ecr_repository_url
  pinpoint_to_sqs_sms_callbacks_ecr_arn              = dependency.ecr.outputs.pinpoint_to_sqs_sms_callbacks_ecr_arn
}

terraform {
  source = "../../../aws//pinpoint_to_sqs_sms_callbacks"
}
