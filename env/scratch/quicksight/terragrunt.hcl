terraform {
  source = "../../../aws//quicksight"
}

dependencies {
  paths = ["../common", "../rds", "../eks"]
}

dependency "common" {
  config_path = "../common"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    kms_arn                          = ""
    s3_bucket_sms_usage_id_sanitized = "sns_sms_usage_report_bucket"
    vpc_id                           = ""
    vpc_private_subnets = [
      "",
      "",
      "",
    ]
  }
}

dependency "rds" {
  config_path                             = "../rds"
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    cluster_identifier  = "id"
    database_name       = "database"
    database_subnet_ids = ["subnet-1", "subnet-2"]
  }
}

dependency "eks" {
  config_path                             = "../eks"
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    quicksight_security_group_id = "sg-1"
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  env                              = "staging"
  vpc_id                           = dependency.common.outputs.vpc_id
  vpc_private_subnets              = dependency.common.outputs.vpc_private_subnets # do we need this? getting database subnets from rds
  sns_alert_warning_arn            = dependency.common.outputs.sns_alert_warning_arn
  s3_bucket_sms_usage_sanitized_id = dependency.common.outputs.s3_bucket_sms_usage_sanitized_id
  quicksight_security_group_id     = dependency.eks.outputs.quicksight_security_group_id
  database_name                    = dependency.rds.outputs.database_name
  database_subnet_ids              = dependency.rds.outputs.database_subnet_ids
  rds_instance_id                  = dependency.rds.outputs.rds_instance_id
}
