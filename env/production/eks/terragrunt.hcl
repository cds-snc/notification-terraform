terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/eks?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}

dependencies {
  paths = ["../common", "../dns", "../cloudfront"]
}

dependency "common" {
  config_path = "../common"
}

dependency "dns" {
  config_path = "../dns"
}

dependency "cloudfront" {
  config_path = "../cloudfront"
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
  eks_cluster_name                       = "notification-canada-ca-production-eks-cluster"
  eks_cluster_version                    = "1.22"
  eks_addon_coredns_version              = "v1.8.7-eksbuild.1"
  eks_addon_kube_proxy_version           = "v1.22.6-eksbuild.1"
  eks_addon_vpc_cni_version              = "v1.11.0-eksbuild.1"  
  eks_node_ami_version                   = "1.22.9-20220725"
  sign_in_waf_rate_limit                 = 100
}
