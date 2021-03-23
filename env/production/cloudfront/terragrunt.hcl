# Uses GitHub tags for release management
#
terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/cloudfront?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}

dependency "common" {
  config_path = "../common"
}

dependency "dns" {
  config_path = "../dns"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  asset_bucket_regional_domain_name         = dependency.common.outputs.asset_bucket_regional_domain_name
  cloudfront_default_oai_arn                = dependency.common.outputs.cloudfront_default_oai_arn
  aws_acm_assets_notification_canada_ca_arn = dependency.dns.outputs.aws_acm_assets_notification_canada_ca_arn
}
