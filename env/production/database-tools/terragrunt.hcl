terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/database-tools?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}

dependencies {
  paths = ["../common", "../eks"]
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
    database-tools-securitygroup = ""
    database-tools-db-securitygroup = ""
  }
}


include {
  path = find_in_parent_folders()
}

inputs = {
  billing_tag_key                 = "CostCenter"
  billing_tag_value               = "notification-canada-ca-staging"
  database-tools-securitygroup    = dependency.eks.outputs.database-tools-securitygroup
  database-tools-db-securitygroup = dependency.eks.outputs.database-tools-db-securitygroup
}