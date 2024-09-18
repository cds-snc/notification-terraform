locals {
  inputs = jsondecode(read_tfvars_file(find_in_parent_folders("./aws/${get_env("ENVIRONMENT")}.tfvars")))
}

inputs = merge(
  local.inputs,
  {
    elb_account_ids = {
      "${local.inputs.region}" = "${local.inputs.elb_account_id}"
    }
    cbs_satellite_bucket_name = "cbs-satellite-${local.inputs.account_id}"
  }
)

terraform {

}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.66"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 3.3"
    }
  }
}

provider "aws" {
  region              = "${local.inputs.region}"
  allowed_account_ids = [${local.inputs.account_id}]
}

provider "aws" {
  alias               = "us-west-2"
  region              = "us-west-2"
  allowed_account_ids = [${local.inputs.account_id}]
}

provider "aws" {
  alias               = "us-east-1"
  region              = "us-east-1"
  allowed_account_ids = [${local.inputs.account_id}]
}

# For whatever reason, Dev uses the DNS from the Staging account and 
# Production uses the DNS from the Production account, but also has a 
# different name :/  So we need to handle that here with if Logic

%{ if local.inputs.env == "dev" }
provider "aws" {
  alias  = "dns"
  region = "ca-central-1"
  assume_role {
    role_arn = "arn:aws:iam::${local.inputs.staging_account_id}:role/${local.inputs.env}_dns_manager_role"
  }
}
%{ endif }
%{ if local.inputs.env == "staging" }
provider "aws" {
  alias  = "dns"
  region = "ca-central-1"
}

provider "aws" {
  alias  = "staging"
  region = "ca-central-1"
  assume_role {
    role_arn = "arn:aws:iam::${local.inputs.staging_account_id}:role/${local.inputs.env}_dns_manager_role"
  }
}
%{ endif }
%{ if local.inputs.env == "production" }
provider "aws" {
  alias  = "dns"
  region = "ca-central-1"
  assume_role {
    role_arn = "arn:aws:iam::${local.inputs.dns_account_id}:role/notify_${local.inputs.env}_dns_manager"
  }
}
%{ endif }

EOF
}

generate "common_variables" {
  path      = "common_variables.tf"
  if_exists = "overwrite"
  contents  = <<EOF
variable "env" {
  type = string
}

variable "account_budget_limit" {
  type = number
}

variable "account_id" {
  type      = string
  sensitive = true
}

variable "dns_account_id" {
  type      = string
  sensitive = true
}

variable "elb_account_id" {
  type      = string
  sensitive = true
}

variable "elb_account_ids" {
  type      = map(string)
  sensitive = true
}

variable "cbs_satellite_bucket_name" {
  type = string
}

variable "dev_account_id" {
  type      = string
  sensitive = true
}

variable "staging_account_id" {
  type      = string
  sensitive = true
}

variable "production_account_id" {
  type      = string
  sensitive = true
}

variable "sandbox_account_id" {
  type      = string
  sensitive = true
}

variable "scratch_account_id" {
  type      = string
  sensitive = true
}

variable "scratch_account_ids" {
  type      = string
  sensitive = true
}

variable "region" {
  type = string
}

variable "billing_tag_value" {
  type = string
}

variable "api_image_tag" {
  type = string
}

variable "redis_enabled" {
  type = string
}

variable "low_demand_min_concurrency" {
  type = number
}

variable "low_demand_max_concurrency" {
  type = number
}

variable "high_demand_min_concurrency" {
  type = number
}

variable "high_demand_max_concurrency" {
  type = number
}

variable "new_relic_app_name" {
  type = string
}

variable "new_relic_distribution_tracing_enabled" {
  type = string
}

variable "notification_queue_prefix" {
  type = string
}

variable "enable_new_relic" {
  type = bool
}

variable "create_cbs_bucket" {
  type = bool
}

variable "force_destroy_s3" {
  type = bool
}

variable "force_delete_ecr" {
  type = bool
}

variable "force_destroy_athena" {
  type = bool
}

variable "bootstrap" {
  type = bool
}

variable "enable_sentinel_forwarding" {
  type = bool
}

variable "enable_delete_protection" {
  type = bool
}

variable "api_enable_new_relic" {
  type = bool
}

variable "cloudwatch_enabled" {
  type = bool
}

variable "recovery" {
  type = bool
}

variable "rds_snapshot_identifier" {
  type      = string
  sensitive = true
}

variable "rds_version" {
  type = string
}

variable "aws_xray_sdk_enabled" {
  type = bool
}

variable "route53_zone_id" {
  type = string
}

variable "hosted_zone_id" {
  type = string
}

variable "alt_domain" {
  type = string
}

variable "domain" {
  type = string
}

variable "base_domain" {
  type = string
}

variable "perf_test_domain" {
  type = string
}

variable "ses_custom_sending_domains" {
  type = set(string)
}

variable "log_retention_period_days" {
  type = number
}

variable "sensitive_log_retention_period_days" {
  type = number
}

variable "vpc_cidr_block" {
  type = string
}

variable "waf_secret" {
  type      = string
  sensitive = true
}

variable "primary_worker_desired_size" {
  type = number
}

variable "primary_worker_instance_types" {
  type = list(string)
}

variable "secondary_worker_instance_types" {
  type = list(string)
}

variable "node_upgrade" {
  type = bool
}

variable "force_upgrade" {
  type = bool
}

variable "primary_worker_max_size" {
  type = number
}

variable "primary_worker_min_size" {
  type = number
}

variable "eks_cluster_name" {
  type = string
}

variable "eks_cluster_version" {
  type = string
}

variable "eks_addon_coredns_version" {
  type = string
}

variable "eks_addon_kube_proxy_version" {
  type = string
}

variable "eks_addon_vpc_cni_version" {
  type = string
}

variable "eks_addon_ebs_driver_version" {
  type = string
}

variable "eks_node_ami_version" {
  type = string
}

variable "eks_karpenter_ami_id" {
  type = string
}

variable "non_api_waf_rate_limit" {
  type = number
}

variable "api_waf_rate_limit" {
  type = number
}

variable "sign_in_waf_rate_limit" {
  type = number
}

variable "celery_queue_prefix" {
  type = string
}

variable "notify_k8s_namespace" {
  type        = string
  description = "Kubernetes namespace where GC Notify is installed"
}

variable "elasticache_node_count" {
  type = number
}

variable "elasticache_node_number_cache_clusters" {
  type = number
}

variable "elasticache_node_type" {
  type = string
}

variable "client_vpn_access_group_id" {
  type = string
}

variable "client_vpn_saml_metadata" {
  type      = string
  sensitive = true
}

variable "client_vpn_self_service_saml_metadata" {
  type      = string
  sensitive = true
}

variable "blazer_slack_webhook_general_topic" {
  type      = string
  sensitive = true
}

variable "cloudwatch_slack_webhook_warning_topic" {
  type      = string
  sensitive = true
}

variable "cloudwatch_slack_webhook_critical_topic" {
  type      = string
  sensitive = true
}

variable "cloudwatch_slack_webhook_general_topic" {
  type      = string
  sensitive = true
}

variable "slack_channel_warning_topic" {
  type = string
}

variable "slack_channel_critical_topic" {
  type = string
}

variable "slack_channel_general_topic" {
  type = string
}

variable "budget_sre_bot_webhook" {
  type      = string
  sensitive = true
}

variable "cloudwatch_opsgenie_alarm_webhook" {
  type      = string
  sensitive = true
}

variable "new_relic_license_key" {
  type      = string
  sensitive = true
}

variable "new_relic_account_id" {
  type      = string
  sensitive = true
}

variable "new_relic_api_key" {
  type      = string
  sensitive = true
}

variable "new_relic_slack_webhook_url" {
  type      = string
  sensitive = true
}

variable "aws_config_recorder_name" {
  type        = string
  description = "The name of the AWS Configuration Recorder"
}

variable "notify_o11y_google_oauth_client_id" {
  type      = string
  sensitive = true
}

variable "notify_o11y_google_oauth_client_secret" {
  type      = string
  sensitive = true
}

variable "sentinel_customer_id" {
  type      = string
  sensitive = true
}

variable "sentinel_shared_key" {
  type      = string
  sensitive = true
}

variable "heartbeat_api_key" {
  type      = string
  sensitive = true
}

variable "heartbeat_sms_number" {
  type = string
}

variable "schedule_expression" {
  type = string
}

variable "google_cidr_schedule_expression" {
  type = string
}

variable "app_db_user" {
  type      = string
  sensitive = true
}

variable "app_db_user_password" {
  type      = string
  sensitive = true
}

variable "dbtools_password" {
  type      = string
  sensitive = true
}

variable "quicksight_db_user_password" {
  type      = string
  sensitive = true
}

variable "quicksight_db_user_name" {
  type      = string
  sensitive = true
}

variable "rds_cluster_password" {
  type      = string
  sensitive = true
}

variable "rds_instance_count" {
  type = number
}

variable "rds_instance_type" {
  type = string
}

variable "rds_database_name" {
  type = string
}

variable "admin_client_secret" {
  type      = string
  sensitive = true
}

variable "auth_tokens" {
  type      = string
  sensitive = true
}

variable "dangerous_salt" {
  type      = string
  sensitive = true
}

variable "ff_batch_insertion" {
  type = string
}

variable "ff_cloudwatch_metrics_enabled" {
  type = string
}

variable "ff_redis_batch_saving" {
  type = string
}

variable "redis_url" {
  type = string
}

variable "secret_key" {
  type      = string
  sensitive = true
}

variable "notify_sending_domain" {
  type = string
}

variable "sqs_region" {
  type = string
}

variable "gc_notify_service_email" {
  type = string
}

variable "aws_pinpoint_region" {
  type = string
}

variable "perf_test_phone_number" {
  type = string
}

variable "perf_test_email" {
  type = string
}

variable "perf_test_auth_header" {
  type      = string
  sensitive = true
}

variable "billing_tag_key" {
  type = string
}

variable "perf_schedule_expression" {
  type = string
}

variable "perf_test_aws_s3_bucket" {
  type = string
}

variable "perf_test_csv_directory_path" {
  type = string
}

variable "perf_test_sms_template_id" {
  type = string
}

variable "perf_test_bulk_email_template_id" {
  type = string
}

variable "alarm_warning_bulk_bulk_processed_created_delta_threshold" {
  description = "Warning alarm threshold for the difference between processed and created bulk sends"
  type        = number
}

variable "alarm_critical_bulk_bulk_processed_created_delta_threshold" {
  description = "Critical alarm threshold for the difference between processed and created bulk sends"
  type        = number
}

variable "alarm_warning_inflight_processed_created_delta_threshold" {
  description = "Warning alarm threshold for the difference between processed and created inflights"
  type        = number
}

variable "alarm_critical_inflight_processed_created_delta_threshold" {
  description = "Critical alarm threshold for the difference between processed and created inflights"
  type        = number
}

variable "alarm_warning_priority_inflight_processed_created_delta_threshold" {
  description = "Warning alarm threshold for the difference between processed and created priority inflights"
  type        = number
}

variable "alarm_critical_priority_inflight_processed_created_delta_threshold" {
  description = "Critical alarm threshold for the difference between processed and created priority inflights"
  type        = number
}

variable "alarm_warning_normal_inflight_processed_created_delta_threshold" {
  description = "Warning alarm threshold for the difference between processed and created priority inflights"
  type        = number
}

variable "alarm_critical_normal_inflight_processed_created_delta_threshold" {
  description = "Critical alarm threshold for the difference between processed and created priority inflights"
  type        = number
}

variable "alarm_warning_bulk_inflight_processed_created_delta_threshold" {
  description = "Warning alarm threshold for the difference between processed and created priority inflights"
  type        = number
}

variable "alarm_critical_bulk_inflight_processed_created_delta_threshold" {
  description = "Critical alarm threshold for the difference between processed and created priority inflights"
  type        = number
}

variable "alarm_warning_bulk_processed_created_delta_threshold" {
  description = "Warning alarm threshold for the difference between processed and created bulk sends"
  type        = number
}

variable "alarm_critical_bulk_processed_created_delta_threshold" {
  description = "Critical alarm threshold for the difference between processed and created bulk sends"
  type        = number
}

variable "alarm_warning_priority_bulk_processed_created_delta_threshold" {
  description = "Warning alarm threshold for the difference between processed and created bulk sends"
  type        = number
}

variable "alarm_critical_priority_bulk_processed_created_delta_threshold" {
  description = "Critical alarm threshold for the difference between processed and created bulk sends"
  type        = number
}

variable "alarm_warning_normal_bulk_processed_created_delta_threshold" {
  description = "Warning alarm threshold for the difference between processed and created bulk sends"
  type        = number
}

variable "alarm_critical_normal_bulk_processed_created_delta_threshold" {
  description = "Critical alarm threshold for the difference between processed and created bulk sends"
  type        = number
}

variable "alarm_critical_expired_inflights_threshold" {
  description = "Critical alarm threshold for number of expired inflights in 5 minutes"
  type        = number
}

variable "sns_monthly_spend_limit" {
  type = number
}

variable "sns_monthly_spend_limit_us_west_2" {
  type = number
}

variable "sqs_visibility_timeout_default" {
  type = number
}

variable "sqs_visibility_timeout_priority_high" {
  type = number
}

variable "sqs_send_email_high_queue_name" {
  type = string
}

variable "sqs_send_email_medium_queue_name" {
  type = string
}

variable "sqs_send_email_low_queue_name" {
  type = string
}

variable "sqs_send_sms_high_queue_name" {
  type = string
}

variable "sqs_send_sms_medium_queue_name" {
  type = string
}

variable "sqs_send_sms_low_queue_name" {
  type = string
}

variable "sqs_priority_queue_name" {
  type = string
}

variable "sqs_bulk_queue_name" {
  type = string
}

variable "sqs_throttled_sms_queue_name" {
  type = string
}

variable "sqs_db_tasks_queue_name" {
  type = string
}

variable "sqs_priority_db_tasks_queue_name" {
  type = string
}

variable "sqs_normal_db_tasks_queue_name" {
  type = string
}

variable "sqs_bulk_db_tasks_queue_name" {
  type = string
}

variable "alarm_warning_document_download_bucket_size_gb" {
  type = number
}

variable "athena_workgroup_name" {
  description = "Set the name for the athena workgroup"
  type        = string
}

variable "account_budget_alert_emails" {
  description = "List of people who should be alerted when budget thresholds are met"
  type        = list(string)
}

variable "perf_test_email_template_id" {
  type = string
}

variable "perf_test_email_with_attachment_template_id" {
  type = string
}

variable "perf_test_email_with_link_template_id" {
  type = string
}

variable "pr_bot_app_id" {
  type      = string
  sensitive = true
}

variable "pr_bot_private_key" {
  type      = string
  sensitive = true
}

variable "pr_bot_installation_id" {
  type      = string
  sensitive = true
}

variable "system_status_api_url" {
  type = string
}

variable "system_status_bucket_name" {
  type = string
}

variable "system_status_admin_url" {
  type = string
}

variable "status_cert_created" {
  type = string
}

variable "blazer_image_tag" {
  type = string
}

variable "system_status_docker_tag" {
  type = string
}

variable "heartbeat_docker_tag" {
  type = string
}

variable "google_cidr_docker_tag" {
  type = string
}

variable "sns_to_sqs_sms_callbacks_docker_tag" {
  type = string
}

variable "ses_to_sqs_callbacks_docker_tag" {
  type = string
}

variable "ses_receiving_emails_docker_tag" {
  type = string
}

variable "pinpoint_to_sqs_sms_callbacks_docker_tag" {
  type = string
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
    bucket              = "notification-canada-ca-${local.inputs.env}-tf"
    dynamodb_table      = "terraform-state-lock-dynamo"
    region              = "ca-central-1"
    key                 = "${path_relative_to_include()}/terraform.tfstate"
    s3_bucket_tags      = { CostCenter : "notification-canada-ca-${local.inputs.env}" }
    dynamodb_table_tags = { CostCenter : "notification-canada-ca-${local.inputs.env}" }
  }
}