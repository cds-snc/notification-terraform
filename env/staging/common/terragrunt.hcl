dependencies {
  paths = ["../cloudfront"]
}

dependency "cloudfront" {
  config_path = "../cloudfront"
}

terraform {
  source = "../../../aws//common"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  sns_monthly_spend_limit           = 1
  sns_monthly_spend_limit_us_west_2 = 1
  cloudfront_default_oai_arn        = dependency.cloudfront.outputs.cloudfront_default_oai_arn
}
