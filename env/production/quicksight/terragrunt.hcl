terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/quicksight?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
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
    kms_arn                = ""
    s3_bucket_sms_usage_id = "sns_sms_usage_report_bucket"
    vpc_id                 = ""
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
    rds_instance_id     = "id"
    database_name       = "database"
    database_subnet_ids = ["subnet-1", "subnet-2"]
    database_read_write_proxy_endpoint = "changeme"
    database_read_write_proxy_endpoint_host = "changeme"
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
  database_name                = dependency.rds.outputs.database_name
  vpc_id                       = dependency.common.outputs.vpc_id
  vpc_private_subnets          = dependency.common.outputs.vpc_private_subnets # do we need this? getting database subnets from rds
  sns_alert_warning_arn        = dependency.common.outputs.sns_alert_warning_arn
  s3_bucket_sms_usage_id       = dependency.common.outputs.s3_bucket_sms_usage_id
  quicksight_security_group_id = dependency.eks.outputs.quicksight_security_group_id
  database_name                = dependency.rds.outputs.database_name
  database_subnet_ids          = dependency.rds.outputs.database_subnet_ids
  rds_instance_id              = dependency.rds.outputs.rds_instance_id
  database_read_write_proxy_endpoint = dependency.rds.outputs.database_read_write_proxy_endpoint
  database_read_write_proxy_endpoint_host = dependency.rds.outputs.database_read_write_proxy_endpoint_host
}
