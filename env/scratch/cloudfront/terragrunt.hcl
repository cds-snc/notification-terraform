dependencies {
  paths = ["../common", "../dns"]
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    asset_bucket_regional_domain_name = ""
  }
}

dependency "dns" {
  config_path = "../dns"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    aws_acm_assets_notification_canada_ca_arn = ""
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  asset_bucket_regional_domain_name         = dependency.common.outputs.asset_bucket_regional_domain_name
  s3_bucket_asset_bucket_id                 = dependency.common.outputs.s3_bucket_asset_bucket_id
  s3_bucket_asset_bucket_arn                = dependency.common.outputs.s3_bucket_asset_bucket_arn
  aws_acm_assets_notification_canada_ca_arn = dependency.dns.outputs.aws_acm_assets_notification_canada_ca_arn
}

terraform {
  source = "../../../aws//cloudfront"
}

