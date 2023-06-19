terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/database-tools?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
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

dependency "rds" {
  config_path = "../rds"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  vpc_private_subnets               = dependency.common.outputs.vpc_private_subnets
  vpc_id                            = dependency.common.outputs.vpc_id
  billing_tag_key                   = "CostCenter"
  billing_tag_value                 = "notification-canada-ca-production"
  blazer_image_tag                  = "53254711eb1da91f834d933e9663c87bc5974d3d"
  database-tools-securitygroup      = dependency.eks.outputs.database-tools-securitygroup
  database-tools-db-securitygroup   = dependency.eks.outputs.database-tools-db-securitygroup
  database_read_only_proxy_endpoint = dependency.rds.outputs.database_read_only_proxy_endpoint
  notify_url                        = "https://notification.canada.ca"
}
