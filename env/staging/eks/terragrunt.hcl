dependencies {
  paths = ["../common", "../dns", "../cloudfront"]
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    vpc_private_subnets = [
      "subnet-001e585d12cce4d1e",
      "subnet-08de34a9e1a7458dc",
      "subnet-0af8b8402f1d605ff",
    ]
    vpc_public_subnets = [
      "subnet-0cecd9e634daf82d3",
      "subnet-0c7d18c0c51b28b61",
      "subnet-0c91f7c6b8211904b",
    ]
    sns_alert_warning_arn          = ""
    sns_alert_critical_arn         = ""
    sns_alert_general_arn          = ""
    firehose_waf_logs_iam_role_arn = ""
  }
}

dependency "dns" {
  config_path = "../dns"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    aws_acm_notification_canada_ca_arn = ""
  }
}

dependency "cloudfront" {
  config_path = "../cloudfront"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    cloudfront_assets_arn = ""
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  aws_acm_notification_canada_ca_arn     = dependency.dns.outputs.aws_acm_notification_canada_ca_arn
  aws_acm_alt_notification_canada_ca_arn = dependency.dns.outputs.aws_acm_alt_notification_canada_ca_arn
  primary_worker_desired_size            = 5
  primary_worker_instance_types          = ["m5.large"]
  primary_worker_max_size                = 7
  primary_worker_min_size                = 4
  vpc_id                                 = dependency.common.outputs.vpc_id
  vpc_private_subnets                    = dependency.common.outputs.vpc_private_subnets
  vpc_public_subnets                     = dependency.common.outputs.vpc_public_subnets
  sns_alert_warning_arn                  = dependency.common.outputs.sns_alert_warning_arn
  sns_alert_critical_arn                 = dependency.common.outputs.sns_alert_critical_arn
  sns_alert_general_arn                  = dependency.common.outputs.sns_alert_general_arn
  firehose_waf_logs_iam_role_arn         = dependency.common.outputs.firehose_waf_logs_iam_role_arn
  cloudfront_assets_arn                  = dependency.cloudfront.outputs.cloudfront_assets_arn
  eks_cluster_name                       = "notification-canada-ca-staging-eks-cluster"
  eks_cluster_version                    = "1.22"
  eks_addon_coredns_version              = "v1.8.4-eksbuild.1"
  eks_addon_kube_proxy_version           = "v1.21.2-eksbuild.2"
  eks_addon_vpc_cni_version              = "v1.11.0-eksbuild.1"
  eks_node_ami_version                   = "1.22.6-20220429"
}

terraform {
  source = "../../../aws//eks"
}
