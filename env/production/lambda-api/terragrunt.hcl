# Uses GitHub tags for release management
#
terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/lambda-api?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}

dependencies {
  paths = ["../common", "../eks", "../dns"]
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    kms_arn = ""
    vpc_private_subnets = [
      "",
      "",
      "",
    ]
    sns_alert_general_arn           = ""
    sns_alert_warning_arn           = ""
    sns_alert_critical_arn          = ""
    s3_bucket_csv_upload_bucket_arn = ""
  }
}

dependency "eks" {
  config_path = "../eks"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs = {
    eks-cluster-securitygroup = ""
  }
}

dependency "dns" {
  config_path = "../dns"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs = {
    aws_acm_notification_canada_ca_arn = ""
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  env                                    = "production"
  admin_base_url                         = "https://notification.canada.ca"
  api_domain_name                        = "api.notification.canada.ca"
  api_lambda_domain_name                 = "api-lambda.notification.canada.ca"
  api_image_tag                          = "release"
  eks_cluster_securitygroup              = dependency.eks.outputs.eks-cluster-securitygroup
  vpc_private_subnets                    = dependency.common.outputs.vpc_private_subnets
  redis_enabled                          = "1"
  low_demand_min_concurrency             = 1
  low_demand_max_concurrency             = 5
  high_demand_min_concurrency            = 1
  high_demand_max_concurrency            = 10
  csv_upload_bucket_arn                  = dependency.common.outputs.s3_bucket_csv_upload_bucket_arn
  new_relic_app_name                     = "notification-lambda-api-production"
  new_relic_distribution_tracing_enabled = "true"
  notification_queue_prefix              = "eks-notification-canada-ca"
  redis_enabled                          = 1
  certificate_arn                        = dependency.dns.outputs.aws_acm_notification_canada_ca_arn
  sns_alert_warning_arn                  = dependency.common.outputs.sns_alert_warning_arn
  sns_alert_critical_arn                 = dependency.common.outputs.sns_alert_critical_arn
  ff_cloudwatch_metrics_enabled          = "true"
}
