terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/eks?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}

dependencies {
  paths = ["../common", "../cloudfront"]
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    ip_blocklist_arn                          = ""
    re_admin_arn                              = ""
    re_api_arn                                = ""
    notification_base_url_regex_arn           = ""
    re_document_download_arn                  = ""
    re_documentation_arn                      = ""
    private-links-vpc-endpoints-securitygroup = ""
    private-links-gateway-prefix-list-ids     = []
  }
}

dependency "cloudfront" {
  config_path = "../cloudfront"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  primary_worker_desired_size               = 5
  primary_worker_instance_types             = ["m5.large"]
  secondary_worker_instance_types           = ["m5.large"]
  nodeUpgrade                               = false  
  primary_worker_max_size                   = 7
  primary_worker_min_size                   = 4
  vpc_id                                    = dependency.common.outputs.vpc_id
  vpc_private_subnets                       = dependency.common.outputs.vpc_private_subnets
  vpc_public_subnets                        = dependency.common.outputs.vpc_public_subnets
  sns_alert_warning_arn                     = dependency.common.outputs.sns_alert_warning_arn
  sns_alert_critical_arn                    = dependency.common.outputs.sns_alert_critical_arn
  sns_alert_general_arn                     = dependency.common.outputs.sns_alert_general_arn
  firehose_waf_logs_iam_role_arn            = dependency.common.outputs.firehose_waf_logs_iam_role_arn
  cloudfront_assets_arn                     = dependency.cloudfront.outputs.cloudfront_assets_arn
  eks_cluster_name                          = "notification-canada-ca-production-eks-cluster"
  eks_cluster_version                       = "1.27"
  eks_addon_coredns_version                 = "v1.10.1-eksbuild.2"
  eks_addon_kube_proxy_version              = "v1.27.1-eksbuild.1"
  eks_addon_vpc_cni_version                 = "v1.13.2-eksbuild.1"
  eks_node_ami_version                      = "1.27.3-20230728"
  non_api_waf_rate_limit                    = 500
  api_waf_rate_limit                        = 30000
  sign_in_waf_rate_limit                    = 100
  ip_blocklist_arn                          = dependency.common.outputs.ip_blocklist_arn
  re_admin_arn                              = dependency.common.outputs.re_admin_arn
  re_api_arn                                = dependency.common.outputs.re_api_arn
  re_document_download_arn                  = dependency.common.outputs.re_document_download_arn
  re_documentation_arn                      = dependency.common.outputs.re_documentation_arn
  notification_base_url_regex_arn           = dependency.common.outputs.notification_base_url_regex_arn  
  private-links-vpc-endpoints-securitygroup = dependency.common.outputs.private-links-vpc-endpoints-securitygroup
  private-links-gateway-prefix-list-ids     = dependency.common.outputs.private-links-gateway-prefix-list-ids
}
