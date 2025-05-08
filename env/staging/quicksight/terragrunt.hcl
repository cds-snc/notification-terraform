terraform {
  source = "${get_env("ENVIRONMENT") == "production" ? "git::https://github.com/cds-snc/notification-terraform//aws/quicksight?ref=v${get_env("INFRASTRUCTURE_VERSION")}" : "../../../aws//quicksight"}"
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
    kms_arn                                     = ""
    s3_bucket_sms_usage_sanitized_ca_central_id = "sns_sms_usage_report_bucket"
    s3_bucket_sms_usage_sanitized_us_west_id    = "sns_sms_usage_report_bucket_2"
    vpc_id                                      = ""
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
    kms_arn                          = ""
    s3_bucket_sms_usage_sanitized_id = "sns_sms_usage_report_bucket"
    vpc_id                           = ""
    rds_reader_instance_ids          = ["notification-canada-ca-staging-instance-1", "notification-canada-ca-staging-instance-2"]
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
  vpc_id                                      = dependency.common.outputs.vpc_id
  sns_alert_warning_arn                       = dependency.common.outputs.sns_alert_warning_arn
  s3_bucket_sms_usage_sanitized_ca_central_id = dependency.common.outputs.s3_bucket_sms_usage_sanitized_ca_central_id
  s3_bucket_sms_usage_sanitized_us_west_id    = dependency.common.outputs.s3_bucket_sms_usage_sanitized_us_west_id
  quicksight_security_group_id                = dependency.eks.outputs.quicksight_security_group_id
  database_name                               = dependency.rds.outputs.database_name
  database_subnet_ids                         = dependency.rds.outputs.database_subnet_ids
  rds_reader_instance_id                      = dependency.rds.outputs.rds_reader_instance_ids[0]
}