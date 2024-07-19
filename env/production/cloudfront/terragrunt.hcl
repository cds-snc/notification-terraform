# Uses GitHub tags for release management
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
  s3_bucket_asset_bucket_id                 = dependency.common.outputs.s3_bucket_asset_bucket_id
  s3_bucket_asset_bucket_arn                = dependency.common.outputs.s3_bucket_asset_bucket_arn
  route53_zone_id                           = dependency.dns.outputs.route53_zone_id
}
