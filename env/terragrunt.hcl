  locals {
  #vars = read_terragrunt_config("../env_vars.hcl")
  vars = yamldecode(file(find_in_parent_folders(get_env("TG_VAR_FILE", "env_vars.yaml"))))
}

inputs = {
  # ELB Account IDs is static
  elb_account_ids = {
    "ca-central-1" = "985666609251"
  }

  # Account Setup
  account_id         = "${local.vars.inputs.account_id}"
  staging_account_id = local.vars.inputs.staging_account_id
  new_relic_account_id      = local.vars.inputs.new_relic_account_id
  
  # Global Environment Setup
  env        = local.vars.inputs.env
  region     = local.vars.inputs.region  
  base_domain = local.vars.inputs.base_domain
  alt_base_domain = local.vars.inputs.alt_base_domain
  ses_custom_sending_domains = local.vars.inputs.ses_custom_sending_domains
  route53_zone_arn = local.vars.inputs.route53_zone_arn
  sentinel_customer_id = local.vars.inputs.sentinel_customer_id
  sentinel_shared_key = local.vars.inputs.sentinel_shared_key
  athena_workgroup_name = local.vars.inputs.athena_workgroup_name
  billing_tag_value = local.vars.inputs.billing_tag_value
  
  # Environment Configuration Options
  bootstrap = local.vars.inputs.bootstrap
  create_cbs_bucket = local.vars.inputs.create_cbs_bucket
  cbs_satellite_bucket_name = local.vars.inputs.cbs_satellite_bucket_name
  enable_sentinel_forwarding = local.vars.inputs.enable_sentinel_forwarding
  enable_delete_protection = local.vars.inputs.enable_delete_protection
  force_destroy_s3 = local.vars.inputs.force_destroy_s3
  force_delete_ecr = local.vars.inputs.force_delete_ecr

  # Slack Configuration
  cloudwatch_opsgenie_alarm_webhook = local.vars.inputs.cloudwatch_opsgenie_alarm_webhook
  cloudwatch_slack_webhook_warning_topic = local.vars.inputs.cloudwatch_slack_webhook_warning_topic
  cloudwatch_slack_webhook_critical_topic = local.vars.inputs.cloudwatch_slack_webhook_critical_topic
  cloudwatch_slack_webhook_general_topic = local.vars.inputs.cloudwatch_slack_webhook_general_topic
  slack_channel_warning_topic = local.vars.inputs.slack_channel_warning_topic
  slack_channel_critical_topic = local.vars.inputs.slack_channel_critical_topic
  slack_channel_general_topic = local.vars.inputs.slack_channel_general_topic
  # Prevents repeated creation of the Slack lambdas if already existing.
  # This is capitalized because a module is expecting this format.
  RECREATE_MISSING_LAMBDA_PACKAGE = local.vars.inputs.RECREATE_MISSING_LAMBDA_PACKAGE

  # SQS Configuration
  sqs_priority_db_tasks_queue_name                                   = local.vars.inputs.sqs_priority_db_tasks_queue_name
  sqs_normal_db_tasks_queue_name                                     = local.vars.inputs.sqs_normal_db_tasks_queue_name
  sqs_bulk_db_tasks_queue_name                                       = local.vars.inputs.sqs_bulk_db_tasks_queue_name

  # SNS Configuration
  sns_monthly_spend_limit                                            = local.vars.inputs.sns_monthly_spend_limit
  sns_monthly_spend_limit_us_west_2                                  = local.vars.inputs.sns_monthly_spend_limit_us_west_2

  # WAF Configuration
  waf_secret=local.vars.inputs.waf_secret
  non_api_waf_rate_limit = local.vars.inputs.non_api_waf_rate_limit
  api_waf_rate_limit = local.vars.inputs.api_waf_rate_limit
  sign_in_waf_rate_limit = local.vars.inputs.sign_in_waf_rate_limit  
  
  # API Configuration
  api_image_tag = local.vars.inputs.api_image_tag
  api_enable_new_relic = local.vars.inputs.api_enable_new_relic
  new_relic_license_key = local.vars.inputs.new_relic_license_key
  dangerous_salt = local.vars.inputs.dangerous_salt
  ff_cloudwatch_metrics_enabled = local.vars.inputs.ff_cloudwatch_metrics_enabled
  redis_enabled = local.vars.inputs.redis_enabled
  low_demand_min_concurrency = local.vars.inputs.low_demand_min_concurrency
  low_demand_max_concurrency = local.vars.inputs.low_demand_max_concurrency
  high_demand_min_concurrency = local.vars.inputs.high_demand_min_concurrency
  high_demand_max_concurrency = local.vars.inputs.high_demand_max_concurrency
  new_relic_app_name = local.vars.inputs.new_relic_app_name
  new_relic_distribution_tracing_enabled = local.vars.inputs.new_relic_distribution_tracing_enabled
  notification_queue_prefix = local.vars.inputs.notification_queue_prefix

  
  # Heartbeat Configuration
  heartbeat_api_key = local.vars.inputs.heartbeat_api_key
  heartbeat_template_id = local.vars.inputs.heartbeat_template_id
  schedule_expression = local.vars.inputs.schedule_expression

  # Google CIDR Lambda Configuration
  google_cidr_schedule_expression = local.vars.inputs.google_cidr_schedule_expression

  # RDS Configuration
  rds_cluster_password = local.vars.inputs.rds_cluster_password
  app_db_user = local.vars.inputs.app_db_user
  app_db_user_password = local.vars.inputs.app_db_user_password
  dbtools_password = local.vars.inputs.dbtools_password
  rds_instance_count = local.vars.inputs.rds_instance_count
  rds_instance_type = local.vars.inputs.rds_instance_type

  # Elasticache (Redis) Configuration
  elasticache_node_count                 = local.vars.inputs.elasticache_node_count
  elasticache_node_number_cache_clusters = local.vars.inputs.elasticache_node_number_cache_clusters
  elasticache_node_type                  = local.vars.inputs.elasticache_node_type

  #EKS Configuration
  eks_cluster_name = local.vars.inputs.eks_cluster_name
  eks_cluster_version = local.vars.inputs.eks_cluster_version
  eks_addon_coredns_version = local.vars.inputs.eks_addon_coredns_version
  eks_addon_kube_proxy_version = local.vars.inputs.eks_addon_kube_proxy_version
  eks_addon_vpc_cni_version = local.vars.inputs.eks_addon_vpc_cni_version
  eks_node_ami_version = local.vars.inputs.eks_node_ami_version

  primary_worker_desired_size = local.vars.inputs.primary_worker_desired_size
  primary_worker_instance_types = local.vars.inputs.primary_worker_instance_types
  primary_worker_max_size = local.vars.inputs.primary_worker_max_size
  primary_worker_min_size = local.vars.inputs.primary_worker_min_size

  # SES Receiving Emails Configuration
  sqs_region = local.vars.inputs.sqs_region
  celery_queue_prefix = local.vars.inputs.celery_queue_prefix
  gc_notify_service_email = local.vars.inputs.gc_notify_service_email

  # Blazer Configuration
  blazer_image_tag                  = local.vars.inputs.blazer_image_tag
  notify_o11y_google_oauth_client_id = local.vars.inputs.notify_o11y_google_oauth_client_id
  notify_o11y_google_oauth_client_secret = local.vars.inputs.notify_o11y_google_oauth_client_secret

  # Performance Test
  perf_test_domain = local.vars.inputs.perf_test_domain
  perf_test_phone_number = local.vars.inputs.perf_test_phone_number
  perf_test_email = local.vars.inputs.perf_test_email
  perf_test_auth_header = local.vars.inputs.perf_test_auth_header
  aws_pinpoint_region       = local.vars.inputs.perf_test_auth_header
  billing_tag_key                             = local.vars.inputs.billing_tag_key
  schedule_expression                         = local.vars.inputs.schedule_expression
  perf_test_aws_s3_bucket                     = local.vars.inputs.perf_test_aws_s3_bucket
  perf_test_csv_directory_path                = local.vars.inputs.perf_test_csv_directory_path
  perf_test_sms_template_id                   = local.vars.inputs.perf_test_sms_template_id
  perf_test_bulk_email_template_id            = local.vars.inputs.perf_test_bulk_email_template_id
  perf_test_email_template_id                 = local.vars.inputs.perf_test_email_template_id
  perf_test_email_with_attachment_template_id = local.vars.inputs.perf_test_email_with_attachment_template_id
  perf_test_email_with_link_template_id       = local.vars.inputs.perf_test_email_with_link_template_id

  # Alarm Configuration
  alarm_warning_document_download_bucket_size_gb                     = local.vars.inputs.alarm_warning_document_download_bucket_size_gb
  alarm_warning_inflight_processed_created_delta_threshold           = local.vars.inputs.alarm_warning_inflight_processed_created_delta_threshold
  alarm_critical_inflight_processed_created_delta_threshold          = local.vars.inputs.alarm_critical_inflight_processed_created_delta_threshold
  alarm_warning_priority_inflight_processed_created_delta_threshold  = local.vars.inputs.alarm_warning_priority_inflight_processed_created_delta_threshold
  alarm_critical_priority_inflight_processed_created_delta_threshold = local.vars.inputs.alarm_critical_priority_inflight_processed_created_delta_threshold
  alarm_warning_normal_inflight_processed_created_delta_threshold    = local.vars.inputs.alarm_warning_normal_inflight_processed_created_delta_threshold
  alarm_critical_normal_inflight_processed_created_delta_threshold   = local.vars.inputs.alarm_critical_normal_inflight_processed_created_delta_threshold
  alarm_warning_bulk_inflight_processed_created_delta_threshold      = local.vars.inputs.alarm_warning_bulk_inflight_processed_created_delta_threshold
  alarm_critical_bulk_inflight_processed_created_delta_threshold     = local.vars.inputs.alarm_critical_bulk_inflight_processed_created_delta_threshold
  alarm_warning_bulk_processed_created_delta_threshold               = local.vars.inputs.alarm_warning_bulk_processed_created_delta_threshold
  alarm_critical_bulk_processed_created_delta_threshold              = local.vars.inputs.alarm_critical_bulk_processed_created_delta_threshold
  alarm_warning_priority_bulk_processed_created_delta_threshold      = local.vars.inputs.alarm_warning_priority_bulk_processed_created_delta_threshold
  alarm_critical_priority_bulk_processed_created_delta_threshold     = local.vars.inputs.alarm_critical_priority_bulk_processed_created_delta_threshold
  alarm_warning_normal_bulk_processed_created_delta_threshold        = local.vars.inputs.alarm_warning_normal_bulk_processed_created_delta_threshold
  alarm_critical_normal_bulk_processed_created_delta_threshold       = local.vars.inputs.alarm_critical_normal_bulk_processed_created_delta_threshold
  alarm_warning_bulk_bulk_processed_created_delta_threshold          = local.vars.inputs.alarm_warning_bulk_bulk_processed_created_delta_threshold
  alarm_critical_bulk_bulk_processed_created_delta_threshold         = local.vars.inputs.alarm_critical_bulk_bulk_processed_created_delta_threshold
  alarm_critical_expired_inflights_threshold                         = local.vars.inputs.alarm_critical_expired_inflights_threshold
  
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
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
  alias  = "staging"
  region = "ca-central-1"
  assume_role {
    role_arn = "arn:aws:iam::${local.vars.inputs.staging_account_id}:role/${local.vars.inputs.env}_dns_manager_role"
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

variable "env" {
  description = "The current running environment"
  type        = string
}

variable "region" {
  description = "The current AWS region"
  type        = string
}

variable "base_domain" {
  description = "The root domain for Notify"
  type        = string
}

variable "alt_base_domain" {
  description = "The root domain for Notify"
  type        = string
}

# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions
variable "elb_account_ids" {
  description = "AWS account IDs used by load balancers"
  type        = map(string)
}

variable "cbs_satellite_bucket_name" {
  description = "Name of the Cloud Based Sensor S3 satellite bucket"
  type        = string
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
