terraform {
  source = "../../../aws//ses_to_sqs_email_callbacks"
}

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
    notification_canada_ca_ses_callback_arn = ""
    sns_alert_warning_arn          = ""
    sns_alert_critical_arn         = ""
    sns_alert_ok_arn               = ""
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  billing_tag_value                                   = "notification-canada-ca-sandbox"
  notification_canada_ca_ses_callback_arn             = dependency.common.outputs.notification_canada_ca_ses_callback_arn
  sns_alert_warning_arn                               = dependency.common.outputs.sns_alert_warning_arn
  sns_alert_critical_arn                              = dependency.common.outputs.sns_alert_critical_arn
  sns_alert_ok_arn                                    = dependency.common.outputs.sns_alert_ok_arn
  sqs_eks_notification_canada_cadelivery_receipts_arn = dependency.common.outputs.sqs_eks_notification_canada_cadelivery_receipts_arn
  ses_to_sqs_email_callbacks_ecr_arn                  = dependency.ecr.outputs.ses_to_sqs_email_callbacks_ecr_arn
  ses_to_sqs_email_callbacks_ecr_repository_url       = dependency.ecr.outputs.ses_to_sqs_email_callbacks_ecr_repository_url
}

