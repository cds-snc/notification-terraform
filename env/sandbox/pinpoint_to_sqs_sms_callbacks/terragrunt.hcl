dependencies {
  paths = ["../common", "../ecr"]
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
    sns_monthly_spend_limit                      = 1
    celery_queue_prefix                          = ""
    sqs_send_sms_high_queue_delay_warning_arn    = ""
    sqs_send_sms_high_queue_delay_critical_arn   = ""
    sqs_send_sms_medium_queue_delay_warning_arn  = ""
    sqs_send_sms_medium_queue_delay_critical_arn = ""
    sqs_send_sms_low_queue_delay_warning_arn     = ""
    sqs_send_sms_low_queue_delay_critical_arn    = ""
  }
}

dependency "ecr" {
  config_path = "../ecr"
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
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
  billing_tag_value                                  = "notification-canada-ca-sandbox"
  sns_alert_warning_arn                              = dependency.common.outputs.sns_alert_warning_arn
  sns_alert_critical_arn                             = dependency.common.outputs.sns_alert_critical_arn
  sns_alert_ok_arn                                   = dependency.common.outputs.sns_alert_ok_arn
  sqs_deliver_receipts_queue_arn                     = dependency.common.outputs.sqs_deliver_receipts_queue_arn
  pinpoint_to_sqs_sms_callbacks_ecr_repository_url   = dependency.ecr.outputs.pinpoint_to_sqs_sms_callbacks_ecr_repository_url
  pinpoint_to_sqs_sms_callbacks_ecr_arn              = dependency.ecr.outputs.pinpoint_to_sqs_sms_callbacks_ecr_arn
  sms_monthly_spend_limit                            = dependency.common.outputs.sns_monthly_spend_limit
  celery_queue_prefix                                = dependency.common.outputs.celery_queue_prefix
  sqs_send_sms_high_queue_delay_warning_arn          = dependency.common.outputs.sqs_send_sms_high_queue_delay_warning_arn
  sqs_send_sms_high_queue_delay_critical_arn         = dependency.common.outputs.sqs_send_sms_high_queue_delay_critical_arn
  sqs_send_sms_medium_queue_delay_warning_arn        = dependency.common.outputs.sqs_send_sms_medium_queue_delay_warning_arn
  sqs_send_sms_medium_queue_delay_critical_arn       = dependency.common.outputs.sqs_send_sms_medium_queue_delay_critical_arn
  sqs_send_sms_low_queue_delay_warning_arn           = dependency.common.outputs.sqs_send_sms_low_queue_delay_warning_arn
  sqs_send_sms_low_queue_delay_critical_arn          = dependency.common.outputs.sqs_send_sms_low_queue_delay_critical_arn
}

terraform {
  source = "../../../aws//pinpoint_to_sqs_sms_callbacks"
}
