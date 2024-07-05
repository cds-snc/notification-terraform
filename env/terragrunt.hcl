locals {
  vars = read_terragrunt_config("../${get_env("ENVIRONMENT")}.hcl")
  # dns_role is very fragile - if not set exactly as below, terraform fmt will fail in github actions.
  # This is required for the dynamic provider for DNS configuration. In staging and production, no role assumption is required,
  # so this will be empty. In scratch/dynamic environments, role assumption is required.
  dns_role           = local.vars.inputs.env == "production" || local.vars.inputs.env == "staging" ? "" : "\n  assume_role {\n    role_arn = \"arn:aws:iam::${local.vars.inputs.dns_account_id}:role/${local.vars.inputs.env}_dns_manager_role\"\n  }"
  
}

inputs = {
  ## AWS
  account_budget_limit                      = local.vars.inputs.account_budget_limit
  account_id                                = local.vars.inputs.account_id
  dns_account_id                            = local.vars.inputs.dns_account_id
  region                                    = local.vars.inputs.region

  ## DNS

  alt_domain                                = local.vars.inputs.alt_domain
  domain                                    = local.vars.inputs.domain
  perf_test_domain                          = local.vars.inputs.perf_test_domain
  route53_zone_arn                          = local.vars.inputs.route53_zone_arn
  ses_custom_sending_domains                = local.vars.inputs.ses_custom_sending_domains

  ## ENVIRONMENT
  env                                       = local.vars.inputs.env
  api_enable_new_relic                      = local.vars.inputs.api_enable_new_relic
  bootstrap                                 = local.vars.inputs.bootstrap
  cloudwatch_enabled                        = local.vars.inputs.cloudwatch_enabled
  create_cbs_bucket                         = local.vars.inputs.create_cbs_bucket
  enable_delete_protection                  = local.vars.inputs.enable_delete_protection
  enable_sentinel_forwarding                = local.vars.inputs.enable_sentinel_forwarding
  force_delete_ecr                          = local.vars.inputs.force_delete_ecr
  force_destroy_athena                      = local.vars.inputs.force_destroy_athena
  force_destroy_s3                          = local.vars.inputs.force_destroy_s3

  ## LOGGING
  log_retention_period_days                 = local.vars.inputs.log_retention_period_days
  sensitive_log_retention_period_days       = local.vars.inputs.sensitive_log_retention_period_days

  ## VPC
  vpc_cidr_block                            = local.vars.inputs.vpc_cidr_block
  waf_secret                                = local.vars.inputs.waf_secret
  elb_account_ids                           = local.vars.inputs.elb_account_ids
  non_api_waf_rate_limit                    = local.vars.inputs.non_api_waf_rate_limit
  api_waf_rate_limit                        = local.vars.inputs.api_waf_rate_limit
  sign_in_waf_rate_limit                    = local.vars.inputs.sign_in_waf_rate_limit

  ## EKS
  primary_worker_desired_size               = local.vars.inputs.primary_worker_desired_size
  primary_worker_instance_types             = local.vars.inputs.primary_worker_instance_types
  secondary_worker_instance_types           = local.vars.inputs.secondary_worker_instance_types
  node_upgrade                              = local.vars.inputs.node_upgrade
  force_upgrade                             = local.vars.inputs.force_upgrade
  primary_worker_max_size                   = local.vars.inputs.primary_worker_max_size
  primary_worker_min_size                   = local.vars.inputs.primary_worker_min_size
  eks_cluster_name                          = local.vars.inputs.eks_cluster_name
  eks_cluster_version                       = local.vars.inputs.eks_cluster_version
  eks_addon_coredns_version                 = local.vars.inputs.eks_addon_coredns_version
  eks_addon_kube_proxy_version              = local.vars.inputs.eks_addon_kube_proxy_version
  eks_addon_vpc_cni_version                 = local.vars.inputs.eks_addon_vpc_cni_version
  eks_addon_ebs_driver_version              = local.vars.inputs.eks_addon_ebs_driver_version
  eks_node_ami_version                      = local.vars.inputs.eks_node_ami_version
  eks_karpenter_ami_id                      = local.vars.inputs.eks_karpenter_ami_id

  ## ELASTICACHE
  elasticache_node_count                    = local.vars.inputs.elasticache_node_count
  elasticache_node_number_cache_clusters    = local.vars.inputs.elasticache_node_number_cache_clusters
  elasticache_node_type                     = local.vars.inputs.elasticache_node_type

  ## VPN
  client_vpn_access_group_id                = local.vars.inputs.client_vpn_access_group_id
  client_vpn_saml_metadata                  = local.vars.inputs.client_vpn_saml_metadata
  client_vpn_self_service_saml_metadata     = local.vars.inputs.client_vpn_self_service_saml_metadata

  ## SLACK INTEGRATION
  blazer_slack_webhook_general_topic        = local.vars.inputs.blazer_slack_webhook_general_topic
  cloudwatch_slack_webhook_critical_topic   = local.vars.inputs.cloudwatch_slack_webhook_critical_topic
  cloudwatch_slack_webhook_general_topic    = local.vars.inputs.cloudwatch_slack_webhook_general_topic
  cloudwatch_slack_webhook_warning_topic    = local.vars.inputs.cloudwatch_slack_webhook_warning_topic
  slack_channel_critical_topic              = local.vars.inputs.slack_channel_critical_topic
  slack_channel_general_topic               = local.vars.inputs.slack_channel_general_topic
  slack_channel_warning_topic               = local.vars.inputs.slack_channel_warning_topic

  ## MONITORING
  athena_workgroup_name                     = local.vars.inputs.athena_workgroup_name
  budget_sre_bot_webhook                    = local.vars.inputs.budget_sre_bot_webhook
  cloudwatch_opsgenie_alarm_webhook         = local.vars.inputs.cloudwatch_opsgenie_alarm_webhook
  mixpanel_project_token                    = local.vars.inputs.mixpanel_project_token
  new_relic_account_id                      = local.vars.inputs.new_relic_account_id
  new_relic_api_key                         = local.vars.inputs.new_relic_api_key
  new_relic_license_key                     = local.vars.inputs.new_relic_license_key
  notify_o11y_google_oauth_client_id        = local.vars.inputs.notify_o11y_google_oauth_client_id
  notify_o11y_google_oauth_client_secret    = local.vars.inputs.notify_o11y_google_oauth_client_secret
  sentinel_customer_id                      = local.vars.inputs.sentinel_customer_id
  sentinel_shared_key                       = local.vars.inputs.sentinel_shared_key
  sentry_url                                = local.vars.inputs.sentry_url

  ## HEARTBEAT
  heartbeat_api_key                         = local.vars.inputs.heartbeat_api_key
  heartbeat_sms_number                      = local.vars.inputs.heartbeat_sms_number
  heartbeat_template_id                     = local.vars.inputs.heartbeat_template_id
  schedule_expression                       = local.vars.inputs.schedule_expression

  ## LAMBDA GOOGLE CIDR
  google_cidr_schedule_expression           = local.vars.inputs.google_cidr_schedule_expression

  ## RDS
  app_db_user                               = local.vars.inputs.app_db_user
  app_db_user_password                      = local.vars.inputs.app_db_user_password
  dbtools_password                          = local.vars.inputs.dbtools_password
  quicksight_db_user_password               = local.vars.inputs.quicksight_db_user_password
  rds_cluster_password                      = local.vars.inputs.rds_cluster_password
  rds_instance_count                        = local.vars.inputs.rds_instance_count
  rds_instance_type                         = local.vars.inputs.rds_instance_type
  rds_database_name                         = local.vars.inputs.rds_database_name

  ## NOTIFY-ADMIN
  admin_client_secret                       = local.vars.inputs.admin_client_secret
  auth_tokens                               = local.vars.inputs.auth_tokens
  crm_github_personal_access_token          = local.vars.inputs.crm_github_personal_access_token
  gc_articles_api_auth_password             = local.vars.inputs.gc_articles_api_auth_password
  gc_articles_api_auth_username             = local.vars.inputs.gc_articles_api_auth_username

  ## NOTIFY-API/CELERY
  RECREATE_MISSING_LAMBDA_PACKAGE           = local.vars.inputs.RECREATE_MISSING_LAMBDA_PACKAGE
  allow_html_service_ids                    = local.vars.inputs.allow_html_service_ids
  bulk_send_test_service_id                 = local.vars.inputs.bulk_send_test_service_id
  celery_queue_prefix                       = local.vars.inputs.celery_queue_prefix
  dangerous_salt                            = local.vars.inputs.dangerous_salt
  ff_abtest_service_id                      = local.vars.inputs.ff_abtest_service_id
  ff_batch_insertion                        = local.vars.inputs.ff_batch_insertion
  ff_cloudwatch_metrics_enabled             = local.vars.inputs.ff_cloudwatch_metrics_enabled
  ff_redis_batch_saving                     = local.vars.inputs.ff_redis_batch_saving
  hc_en_service_id                          = local.vars.inputs.hc_en_service_id
  hc_fr_service_id                          = local.vars.inputs.hc_fr_service_id
  redis_url                                 = local.vars.inputs.redis_url
  secret_key                                = local.vars.inputs.secret_key
  sensitive_services                        = local.vars.inputs.sensitive_services
  api_image_tag                             = local.vars.inputs.api_image_tag
  redis_enabled                             = local.vars.inputs.redis_enabled
  low_demand_min_concurrency                = local.vars.inputs.low_demand_min_concurrency
  low_demand_max_concurrency                = local.vars.inputs.low_demand_max_concurrency
  high_demand_min_concurrency               = local.vars.inputs.high_demand_min_concurrency
  high_demand_max_concurrency               = local.vars.inputs.high_demand_max_concurrency
  new_relic_app_name                        = local.vars.inputs.new_relic_app_name
  new_relic_distribution_tracing_enabled    = local.vars.inputs.new_relic_distribution_tracing_enabled
  ff_cloudwatch_metrics_enabled             = local.vars.inputs.ff_cloudwatch_metrics_enabled

  ## SES_RECEIVING_EMAILS
  schedule_expression                       = local.vars.inputs.schedule_expression
  notify_sending_domain                     = local.vars.inputs.notify_sending_domain
  sqs_region                                = local.vars.inputs.sqs_region
  gc_notify_service_email                   = local.vars.inputs.gc_notify_service_email

  ## PERF TEST
  perf_test_auth_header                     = local.vars.inputs.perf_test_auth_header
  perf_test_email                           = local.vars.inputs.perf_test_email
  perf_test_phone_number                    = local.vars.inputs.perf_test_phone_number
  aws_pinpoint_region                         = local.vars.inputs.aws_pinpoint_region
  schedule_expression                         = local.vars.inputs.schedule_expression
  perf_test_aws_s3_bucket                     = local.vars.inputs.perf_test_aws_s3_bucket
  perf_test_csv_directory_path                = local.vars.inputs.perf_test_csv_directory_path
  perf_test_sms_template_id                   = local.vars.inputs.perf_test_sms_template_id
  perf_test_bulk_email_template_id            = local.vars.inputs.perf_test_bulk_email_template_id
  perf_test_email_template_id                 = local.vars.inputs.perf_test_email_template_id
  perf_test_email_with_attachment_template_id = local.vars.inputs.perf_test_email_with_attachment_template_id
  perf_test_email_with_link_template_id       = local.vars.inputs.perf_test_email_with_link_template_id

  ## PR BOT
  pr_bot_app_id                             = local.vars.inputs.pr_bot_app_id
  pr_bot_installation_id                    = local.vars.inputs.pr_bot_installation_id
  pr_bot_private_key                        = local.vars.inputs.pr_bot_private_key

  ## SYSTEM STATUS
  system_status_admin_url                   = local.vars.inputs.system_status_admin_url
  system_status_api_url                     = local.vars.inputs.system_status_api_url
  system_status_bucket_name                 = local.vars.inputs.system_status_bucket_name
  system_status_schedule_expression         = local.vars.inputs.system_status_schedule_expression
  status_cert_created                       = local.vars.inputs.status_cert_created  

  ## BLAZER
  blazer_image_tag                          = local.vars.inputs.blazer_image_tag


}

terraform {

  before_hook "before_hook" {
    commands     = local.vars.inputs.env == "dev" ? ["apply", "plan"] : []
    execute      = ["${get_repo_root()}/scripts/checkEnvFile.sh", "${get_repo_root()}/aws/dev.tfvars"]
  }

}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region              = var.region
  allowed_account_ids = [var.account_id]
}

provider "aws" {
  alias               = "us-west-2"
  region              = "us-west-2"
  allowed_account_ids = [var.account_id]
}

provider "aws" {
  alias               = "us-east-1"
  region              = "us-east-1"
  allowed_account_ids = [var.account_id]
}

provider "aws" {
  alias  = "dns"
  region = "ca-central-1"${local.dns_role}
}

provider "aws" {
  alias  = "staging"
  region = "ca-central-1"
  assume_role {
    role_arn = "arn:aws:iam::239043911459:role/${local.vars.inputs.env}_dns_manager_role"
  }
}

EOF
}


generate "common_variables" {
  path      = "common_variables.tf"
  if_exists = "overwrite"
  contents  = <<EOF
variable "account_id" {
  description = "(Required) The account ID to perform actions on."
  type        = string
}

variable "domain" {
  description = "The current domain"
  type        = string
}

variable "alt_domain" {
  description = "The alternative domain, if it exists"
  type        = string
}

variable "env" {
  description = "The current running environment"
  type        = string
}

variable "region" {
  description = "The current AWS region"
  type        = string
}

# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions
variable "elb_account_ids" {
  description = "AWS account IDs used by load balancers"
  type        = map(string)
}

variable "cloudwatch_enabled" {
  type        = bool
  default     = true
  description = "Use this flag to enable/disable cloudwatch logs. Useful for saving money on scratch accounts"
}

variable "log_retention_period_days" {
  description = "Log retention period in days for normal logs"
  type        = number
  default     = 0
}

variable "sensitive_log_retention_period_days" {
  description = "Log retention period in days for logs with sensitive information"
  type        = number
  default     = 7
}

EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    encrypt             = true
    bucket              = "notification-canada-ca-${local.vars.inputs.env}-tf"
    dynamodb_table      = "terraform-state-lock-dynamo"
    region              = "ca-central-1"
    key                 = "${path_relative_to_include()}/terraform.tfstate"
    s3_bucket_tags      = { CostCenter : "notification-canada-ca-${local.vars.inputs.env}" }
    dynamodb_table_tags = { CostCenter : "notification-canada-ca-${local.vars.inputs.env}" }
  }
}
