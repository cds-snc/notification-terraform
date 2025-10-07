terraform {
  source = "${get_env("ENVIRONMENT") == "production" ? "git::https://github.com/cds-snc/notification-terraform//aws/github?ref=v${get_env("INFRASTRUCTURE_VERSION")}" : "../../../aws//github"}"
}

dependencies {
  paths = ["../common", "../lambda-admin-pr", "../rds"]
}

dependency "rds" {
  config_path = "../rds"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show", "apply"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    shared_staging_kms_key_id = "mock-shared-test-snapshot"
  }
}

dependency "lambda-admin-pr" {
  config_path = "../lambda-admin-pr"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show", "apply"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    admin_pr_security_group_id = "sg-1234567890abcdef0"
  }
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show", "apply"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    vpc_private_subnets = "subnet-1234567890abcdef0,subnet-1234567890abcdef1"
  }
}

dependency "system_status_static_site" {
  config_path = "../system_status_static_site"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show", "apply"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    system_status_static_site_cloudfront_distribution = "E1234567890ABC"
  }
}

inputs = {
  admin_pr_review_env_security_group_ids                              = dependency.lambda-admin-pr.outputs.admin_pr_security_group_id
  admin_pr_review_env_subnet_ids                                      = dependency.common.outputs.vpc_private_subnets
  shared_staging_kms_key_id                                           = dependency.rds.outputs.shared_staging_kms_key_id                                                            
  system_status_static_site_cloudfront_distribution = dependency.system_status_static_site.outputs.system_status_static_site_cloudfront_distribution
}

include {
  path = find_in_parent_folders()
}
