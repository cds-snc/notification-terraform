terraform {
  source = "${get_env("ENVIRONMENT") == "production" ? "git::https://github.com/cds-snc/notification-terraform//aws/cloudfront?ref=v${get_env("INFRASTRUCTURE_VERSION")}" : "../../../aws//cloudfront"}"
}

dependencies {
  paths = ["../common"]
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "init"]
  mock_outputs = {
    asset_bucket_regional_domain_name = ""
    s3_bucket_asset_bucket_id         = ""
    s3_bucket_asset_bucket_arn        = ""
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  asset_bucket_regional_domain_name         = dependency.common.outputs.asset_bucket_regional_domain_name
  s3_bucket_asset_bucket_id                 = dependency.common.outputs.s3_bucket_asset_bucket_id
  s3_bucket_asset_bucket_arn                = dependency.common.outputs.s3_bucket_asset_bucket_arn
}

