terraform {
  source = "${get_env("ENVIRONMENT") == "production" ? "git::https://github.com/cds-snc/notification-terraform//aws/ses_receiving_emails?ref=v${get_env("INFRASTRUCTURE_VERSION")}" : "../../../aws//ses_receiving_emails"}"
}

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
    sns_alert_warning_arn_us_east_1 = ""
    sns_alert_critical_arn_us_east_1 = ""
    sns_alert_ok_arn_us_east_1 = ""
    sqs_notify_internal_tasks_arn = ""
  }
}

dependency "ecr" {
  config_path = "../ecr"
}


include {
  path = find_in_parent_folders()
}

inputs = {
  sns_alert_warning_arn_us_east_1         = dependency.common.outputs.sns_alert_warning_arn_us_east_1
  sns_alert_critical_arn_us_east_1        = dependency.common.outputs.sns_alert_critical_arn_us_east_1
  sns_alert_ok_arn_us_east_1              = dependency.common.outputs.sns_alert_ok_arn_us_east_1
  sqs_notify_internal_tasks_arn           = dependency.common.outputs.sqs_notify_internal_tasks_arn
  ses_receiving_emails_ecr_repository_url = dependency.ecr.outputs.ses_receiving_emails_ecr_repository_url
  ses_receiving_emails_ecr_arn            = dependency.ecr.outputs.ses_receiving_emails_ecr_arn  
}

