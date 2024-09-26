dependencies {
  paths = ["../common", "../ecr"]
}

dependency "ecr" {
  config_path = "../ecr"
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    sns_deliveries_ca_central_arn           = "arn:aws:logs:ca-central-1:111111111111:log-group:sns/ca-central-1/111111111111/DirectPublishToPhoneNumber"
    sns_deliveries_ca_central_name          = ""
    sns_deliveries_failures_ca_central_arn  = "arn:aws:logs:ca-central-1:111111111111:log-group:sns/ca-central-1/111111111111/DirectPublishToPhoneNumber/Failure"
    sns_deliveries_failures_ca_central_name = ""
    sns_deliveries_us_west_2_arn            = "arn:aws:logs:us-west-2:111111111111:log-group:sns/us-west-2/111111111111/DirectPublishToPhoneNumber"
    sns_deliveries_us_west_2_name           = ""
    sns_deliveries_failures_us_west_2_arn   = "arn:aws:logs:us-west-2:111111111111:log-group:sns/us-west-2/111111111111/DirectPublishToPhoneNumber/Failure"
    sns_deliveries_failures_us_west_2_name  = ""
    sns_alert_warning_arn                   = ""
    sns_alert_critical_arn                  = ""
    sns_alert_ok_arn                        = ""
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  sns_deliveries_ca_central_arn            = dependency.common.outputs.sns_deliveries_ca_central_arn
  sns_deliveries_ca_central_name           = dependency.common.outputs.sns_deliveries_ca_central_name
  sns_deliveries_failures_ca_central_arn   = dependency.common.outputs.sns_deliveries_failures_ca_central_arn
  sns_deliveries_failures_ca_central_name  = dependency.common.outputs.sns_deliveries_failures_ca_central_name
  sns_deliveries_us_west_2_arn             = dependency.common.outputs.sns_deliveries_us_west_2_arn
  sns_deliveries_us_west_2_name            = dependency.common.outputs.sns_deliveries_us_west_2_name
  sns_deliveries_failures_us_west_2_arn    = dependency.common.outputs.sns_deliveries_failures_us_west_2_arn
  sns_deliveries_failures_us_west_2_name   = dependency.common.outputs.sns_deliveries_failures_us_west_2_name
  sns_alert_warning_arn                    = dependency.common.outputs.sns_alert_warning_arn
  sns_alert_critical_arn                   = dependency.common.outputs.sns_alert_critical_arn
  sns_alert_ok_arn                         = dependency.common.outputs.sns_alert_ok_arn
  sns_to_sqs_sms_callbacks_ecr_repository_url   = dependency.ecr.outputs.sns_to_sqs_sms_callbacks_ecr_repository_url
  sns_to_sqs_sms_callbacks_ecr_arn              = dependency.ecr.outputs.sns_to_sqs_sms_callbacks_ecr_arn
}

terraform {
  source = "../../../aws//sns_to_sqs_sms_callbacks"
}
