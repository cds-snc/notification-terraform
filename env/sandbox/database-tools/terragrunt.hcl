terraform {
  source = "${get_env("ENVIRONMENT") == "production" ? "git::https://github.com/cds-snc/notification-terraform//aws/database-tools?ref=v${get_env("INFRASTRUCTURE_VERSION")}" : "../../../aws//database-tools"}"
}

dependencies {
  paths = ["../common", "../eks", "../rds"]
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs = {
    vpc_id = ""
    vpc_private_subnets = [
      "",
      "",
      "",
    ]
    sns_alert_warning_arn = ""
  }
}

dependency "eks" {
  config_path = "../eks"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init", "fmt", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    database-tools-securitygroup    = ""
    database-tools-db-securitygroup = ""
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

dependency "rds" {
  config_path = "../rds"
  
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
  mock_outputs = {
    database_read_only_proxy_endpoint = "thisisamockstring_database_read_only_proxy_endpoint"
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  vpc_private_subnets               = dependency.common.outputs.vpc_private_subnets
  vpc_id                            = dependency.common.outputs.vpc_id
  database-tools-securitygroup      = dependency.eks.outputs.database-tools-securitygroup
  database-tools-db-securitygroup   = dependency.eks.outputs.database-tools-db-securitygroup
  database_read_only_proxy_endpoint = dependency.rds.outputs.database_read_only_proxy_endpoint
  sns_alert_warning_arn             = dependency.common.outputs.sns_alert_warning_arn
}
