terraform {
  source = "${get_env("ENVIRONMENT") == "production" ? "git::https://github.com/cds-snc/notification-terraform//aws/heartbeat?ref=v${get_env("INFRASTRUCTURE_VERSION")}" : "../../../aws//heartbeat"}"
}

dependencies {
  paths = ["../common", "../ecr"]
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

dependency "ecr" {
  config_path = "../ecr"
  
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    heartbeat_ecr_repository_url = "123456789012.dkr.ecr.ca-central-1.amazonaws.com/heartbeat"
    heartbeat_ecr_arn            = "arn:aws:ecr:ca-central-1:123456789012:repository/heartbeat"
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  sns_alert_warning_arn  = dependency.common.outputs.sns_alert_warning_arn
  sns_alert_critical_arn = dependency.common.outputs.sns_alert_critical_arn
  heartbeat_ecr_repository_url = dependency.ecr.outputs.heartbeat_ecr_repository_url
  heartbeat_ecr_arn            = dependency.ecr.outputs.heartbeat_ecr_arn
}
