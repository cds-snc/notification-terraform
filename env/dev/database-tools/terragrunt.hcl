dependencies {
  paths = ["../common", "../eks", "../rds"]
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show", "destroy"]
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
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init", "fmt", "show", "destroy"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    database-tools-securitygroup    = ""
    database-tools-db-securitygroup = ""
  }
}

dependency "rds" {
  config_path = "../rds"
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init", "fmt", "show", "destroy"]
  mock_outputs = {
    database_read_only_proxy_endpoint = "adsfs"
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  vpc_private_subnets               = dependency.common.outputs.vpc_private_subnets
  vpc_id                            = dependency.common.outputs.vpc_id
  billing_tag_key                   = "CostCenter"
  billing_tag_value                 = "notification-canada-ca-dev"
  blazer_image_tag                  = "latest"
  database-tools-securitygroup      = dependency.eks.outputs.database-tools-securitygroup
  database-tools-db-securitygroup   = dependency.eks.outputs.database-tools-db-securitygroup
  database_read_only_proxy_endpoint = dependency.rds.outputs.database_read_only_proxy_endpoint
  sns_alert_warning_arn             = dependency.common.outputs.sns_alert_warning_arn
}

terraform {
  source = "../../../aws//database-tools"
}
