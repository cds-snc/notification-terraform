terraform {
  source = "../../../aws//quicksight"
}

dependencies {
  paths = ["../common", "../rds"]
}

dependency "common" {
  config_path = "../common"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    kms_arn = ""
    vpc_private_subnets = [
      "",
      "",
      "",
    ]
  }
}

dependency "rds" {
  config_path = "../rds"
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    database_name = "database"
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  env                   = "staging"  
  database_name         = dependency.rds.outputs.database_name
  vpc_private_subnets   = dependency.common.outputs.vpc_private_subnets
  sns_alert_warning_arn = dependency.common.outputs.sns_alert_warning_arn
}