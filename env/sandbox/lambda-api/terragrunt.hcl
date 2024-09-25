terraform {
  source = "../../../aws//lambda-api"
}

dependencies {
  paths = ["../common", "../eks", "../ecr", "../rds", "../dns"]
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
    firehose_waf_logs_iam_role_arn  = ""
    ip_blocklist_arn                = ""
    re_api_arn                      = ""
  }
}

dependency "eks" {
  config_path = "../eks"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    eks-cluster-securitygroup = ""
    eks_application_log_group = "eks_application_log_group_name"
  }
}

dependency "ecr" {
  config_path = "../ecr"
}

dependency "dns" {

  config_path = "../dns"

  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs = {
    route53_zone_id = "Z04028033PLSHVOO9ZJ1Z"
  }
}


dependency "rds" {
  config_path = "../rds"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  env                                    = "sandbox"
  api_image_tag                          = "latest"
  vpc_private_subnets                    = dependency.common.outputs.vpc_private_subnets
  redis_enabled                          = "1"
  low_demand_min_concurrency             = 1
  low_demand_max_concurrency             = 5
  high_demand_min_concurrency            = 1
  high_demand_max_concurrency            = 10
  csv_upload_bucket_arn                  = dependency.common.outputs.s3_bucket_csv_upload_bucket_arn
  firehose_waf_logs_iam_role_arn         = dependency.common.outputs.firehose_waf_logs_iam_role_arn
  new_relic_app_name                     = "notification-lambda-api-sandbox"
  new_relic_distribution_tracing_enabled = "true"
  notification_queue_prefix              = "eks-notification-canada-ca"
  redis_enabled                          = 1
  certificate_arn                        = dependency.eks.outputs.aws_acm_notification_canada_ca_arn
  certificate_alt_arn                    = dependency.eks.outputs.aws_acm_alt_notification_canada_ca_arn
  alb_arn_suffix                         = dependency.eks.outputs.alb_arn_suffix
  eks_cluster_securitygroup              = dependency.eks.outputs.eks-cluster-securitygroup
  eks_application_log_group              = dependency.eks.outputs.eks_application_log_group
  sns_alert_warning_arn                  = dependency.common.outputs.sns_alert_warning_arn
  sns_alert_critical_arn                 = dependency.common.outputs.sns_alert_critical_arn
  ff_cloudwatch_metrics_enabled          = "true"
  ip_blocklist_arn                       = dependency.common.outputs.ip_blocklist_arn
  re_api_arn                             = dependency.common.outputs.re_api_arn
  api_waf_rate_limit                     = 30000
  api_lambda_ecr_repository_url          = dependency.ecr.outputs.api_lambda_ecr_repository_url
  api_lambda_ecr_arn                     = dependency.ecr.outputs.api_lambda_ecr_arn
  database_read_only_proxy_endpoint      = dependency.rds.outputs.database_read_only_proxy_endpoint
  database_read_write_proxy_endpoint     = dependency.rds.outputs.database_read_write_proxy_endpoint
  route53_zone_id                        = dependency.dns.outputs.route53_zone_id
}