dependencies {
  paths = ["../common"]
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


include {
  path = find_in_parent_folders()
}

inputs = {
  vpc_private_subnets       = dependency.common.outputs.vpc_private_subnets
  vpc_id                    = dependency.common.outputs.vpc_id
  aws_pinpoint_region       = "ca-central-1"
  billing_tag_key           = "CostCenter"
  billing_tag_value         = "notification-canada-ca-staging"
  database_url              = aws_ssm_parameter.sqlalchemy_database_reader_uri.arn
}

terraform {
  source = "../../../aws//database-tools"
}
