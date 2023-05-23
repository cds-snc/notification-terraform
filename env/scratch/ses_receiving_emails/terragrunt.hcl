terraform {
  source = "../../../aws//ses_receiving_emails"
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
  billing_tag_value                       = "notification-canada-ca-scratch"
  schedule_expression                     = "rate(1 minute)"
  sns_alert_warning_arn_us_east_1         = dependency.common.outputs.sns_alert_warning_arn_us_east_1
  sns_alert_critical_arn_us_east_1        = dependency.common.outputs.sns_alert_critical_arn_us_east_1
  sns_alert_ok_arn_us_east_1              = dependency.common.outputs.sns_alert_ok_arn_us_east_1
  notify_sending_domain                   = "scratch.notification.cdssandbox.xyz"
  sqs_region                              = "ca-central-1"
  celery_queue_prefix                     = "eks-notification-canada-ca"
  gc_notify_service_email                 = "gc.notify.notification.gc@scratch.notification.cdssandbox.xyz"
  sqs_notify_internal_tasks_arn           = dependency.common.outputs.sqs_notify_internal_tasks_arn
  ses_receiving_emails_ecr_repository_url = dependency.ecr.outputs.ses_receiving_emails_ecr_repository_url
  ses_receiving_emails_ecr_arn            = dependency.ecr.outputs.ses_receiving_emails_ecr_arn

}

