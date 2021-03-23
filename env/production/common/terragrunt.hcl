# Uses GitHub tags for release management
#
dependencies {
  paths = ["../cloudfront"]
}

dependency "cloudfront" {
  config_path = "../cloudfront"
}

terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/common?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  sns_monthly_spend_limit           = 10000
  sns_monthly_spend_limit_us_west_2 = 1000
  cloudfront_default_oai_arn        = dependency.cloudfront.outputs.cloudfront_default_oai_arn
}
