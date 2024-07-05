dependencies {
  paths = ["../common", "../ecr"]
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init", "fmt", "show", "destroy"]
  mock_outputs = {
    sns_alert_warning_arn  = ""
    sns_alert_critical_arn = ""
  }
}

dependency "ecr" {
  config_path = "../ecr"
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init", "fmt", "show", "destroy"]
  mock_outputs = {
    heartbeat_ecr_repository_url = ""
    heartbeat_ecr_arn            = ""
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

terraform {
  source = "../../../aws//heartbeat"
}
