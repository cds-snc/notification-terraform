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
    vpc_private_subnets_k8s = [
      "subnet-001e585d12cce4d1e",
      "subnet-08de34a9e1a7458dc",
      "subnet-0af8b8402f1d605ff",
    ]        
    ip_blocklist_arn                          = ""
    re_admin_arn                              = ""
    re_api_arn                                = ""
    notification_base_url_regex_arn           = ""
    re_document_download_arn                  = ""
    re_documentation_arn                      = ""
    private-links-vpc-endpoints-securitygroup = ""
    private-links-gateway-prefix-list-ids     = []
    sqs_send_email_low_queue_name             = ""
    sqs_send_email_medium_queue_name          = ""
    sqs_send_email_high_queue_name            = ""
    sqs_send_sms_low_queue_name               = ""
    sqs_send_sms_medium_queue_name            = ""
    sqs_send_sms_high_queue_name              = ""
    client_vpn_cloudwatch_log_group_name      = "/aws/vpc/client-vpn-endpoint-logs"
    client_vpn_security_group_id              = "sg-1234"
  }
}

dependency "cloudfront" {
  config_path = "../cloudfront"
}

dependency "dns" {

  config_path = "../dns"

  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs = {
    internal_dns_certificate_arn = ""
    internal_dns_zone_id = "ZQSVJUPU6J1EY"
    internal_dns_name = "production.notification.internal.com"
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  primary_worker_desired_size               = 5
  primary_worker_instance_types             = ["r5.large"]
  secondary_worker_instance_types           = ["r5.large"]
  node_upgrade                              = false  
  primary_worker_max_size                   = 8
  primary_worker_min_size                   = 3
  vpc_id                                    = dependency.common.outputs.vpc_id
  vpc_private_subnets                       = dependency.common.outputs.vpc_private_subnets
  vpc_public_subnets                        = dependency.common.outputs.vpc_public_subnets
  vpc_private_subnets_k8s                   = dependency.common.outputs.vpc_private_subnets_k8s
  sns_alert_warning_arn                     = dependency.common.outputs.sns_alert_warning_arn
  sns_alert_critical_arn                    = dependency.common.outputs.sns_alert_critical_arn
  sns_alert_general_arn                     = dependency.common.outputs.sns_alert_general_arn
  firehose_waf_logs_iam_role_arn            = dependency.common.outputs.firehose_waf_logs_iam_role_arn
  cloudfront_assets_arn                     = dependency.cloudfront.outputs.cloudfront_assets_arn
  eks_cluster_name                          = "notification-canada-ca-production-eks-cluster"
  eks_cluster_version                       = "1.29"
  eks_addon_coredns_version                 = "v1.11.1-eksbuild.6"
  eks_addon_kube_proxy_version              = "v1.29.0-eksbuild.3"
  eks_addon_vpc_cni_version                 = "v1.16.2-eksbuild.1"
  eks_addon_ebs_driver_version              = "v1.27.0-eksbuild.1"
  eks_node_ami_version                      = "1.29.0-20240315"
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
  sqs_send_email_low_queue_name             = dependency.common.outputs.sqs_send_email_low_queue_name
  sqs_send_email_medium_queue_name          = dependency.common.outputs.sqs_send_email_medium_queue_name
  sqs_send_email_high_queue_name            = dependency.common.outputs.sqs_send_email_high_queue_name
  sqs_send_sms_low_queue_name               = dependency.common.outputs.sqs_send_sms_low_queue_name
  sqs_send_sms_medium_queue_name            = dependency.common.outputs.sqs_send_sms_medium_queue_name
  sqs_send_sms_high_queue_name              = dependency.common.outputs.sqs_send_sms_high_queue_name
  celery_queue_prefix                       = "eks-notification-canada-ca"
  client_vpn_cloudwatch_log_group_name      = dependency.common.outputs.client_vpn_cloudwatch_log_group_name
  client_vpn_security_group_id              = dependency.common.outputs.client_vpn_security_group_id  
  internal_dns_certificate_arn              = dependency.dns.outputs.internal_dns_certificate_arn
  internal_dns_zone_id                      = dependency.dns.outputs.internal_dns_zone_id
  internal_dns_name                         = dependency.dns.outputs.internal_dns_name

}
