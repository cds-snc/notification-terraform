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
    sns_alert_warning_arn_us_east_1 = ""
    sns_alert_critical_arn_us_east_1 = ""
    sns_alert_ok_arn_us_east_1 = ""
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  billing_tag_value      = "notification-canada-ca-staging"
  schedule_expression    = "rate(1 minute)"
  sns_alert_warning_arn_us_east_1 = dependency.common.outputs.sns_alert_warning_arn_us_east_1
  sns_alert_critical_arn_us_east_1 = dependency.common.outputs.sns_alert_critical_arn_us_east_1
  sns_alert_ok_arn_us_east_1 = dependency.common.outputs.sns_alert_ok_arn_us_east_1
  notify_sending_domain  = "staging.notification.cdssandbox.xyz"
  sqs_region             = "ca-central-1"
  celery_queue_prefix    = "eks-notification-canada-ca"
  gc_notify_service_email = "gc.notify.notification.gc@staging.notification.cdssandbox.xyz"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
provider "aws" {
  region              = "us-east-1"
  allowed_account_ids = [var.account_id]
}
EOF
}

terraform {
  source = "../../../aws//ses_receiving_emails"
}
