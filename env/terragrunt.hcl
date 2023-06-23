locals {
  environment = yamldecode(file(find_in_parent_folders(get_env("TG_VAR_FILE"))))
}

inputs = {
  # ELB Account IDs is static
  elb_account_ids = {
    "ca-central-1" = "985666609251"
  }

  # Account Setup
  account_id         = "${local.environment.account.account_id}"
  staging_account_id = local.environment.account.staging_account_id
  new_relic_account_id      = local.environment.account.new_relic_account_id
  
  # Global Environment Setup
  env        = local.environment.global.env
  region     = local.environment.global.region  
  base_domain = local.environment.global.base_domain
  alt_base_domain = local.environment.global.alt_base_domain
  ses_custom_sending_domains = local.environment.global.ses_custom_sending_domains
  route53_zone_arn = local.environment.global.route53_zone_arn
  sentinel_customer_id = local.environment.global.sentinel_customer_id
  sentinel_shared_key = local.environment.global.sentinel_shared_key
  athena_workgroup_name = local.environment.global.athena_workgroup_name
  billing_tag_value = local.environment.global.billing_tag_value
  
  # Environment Configuration Options
  bootstrap = local.environment.global.configuration.bootstrap
  create_cbs_bucket = local.environment.global.configuration.create_cbs_bucket
  cbs_satellite_bucket_name = local.environment.global.configuration.cbs_satellite_bucket_name
  enable_sentinel_forwarding = local.environment.global.configuration.enable_sentinel_forwarding
  enable_delete_protection = local.environment.global.configuration.enable_delete_protection
  force_destroy_s3 = local.environment.global.configuration.force_destroy_s3
  force_delete_ecr = local.environment.global.configuration.force_delete_ecr

# Alarm Configuration
  alarm_warning_document_download_bucket_size_gb                     = local.environment.alarms.thresholds.alarm_warning_document_download_bucket_size_gb
  alarm_warning_inflight_processed_created_delta_threshold           = local.environment.alarms.thresholds.alarm_warning_inflight_processed_created_delta_threshold
  alarm_critical_inflight_processed_created_delta_threshold          = local.environment.alarms.thresholds.alarm_critical_inflight_processed_created_delta_threshold
  alarm_warning_priority_inflight_processed_created_delta_threshold  = local.environment.alarms.thresholds.alarm_warning_priority_inflight_processed_created_delta_threshold
  alarm_critical_priority_inflight_processed_created_delta_threshold = local.environment.alarms.thresholds.alarm_critical_priority_inflight_processed_created_delta_threshold
  alarm_warning_normal_inflight_processed_created_delta_threshold    = local.environment.alarms.thresholds.alarm_warning_normal_inflight_processed_created_delta_threshold
  alarm_critical_normal_inflight_processed_created_delta_threshold   = local.environment.alarms.thresholds.alarm_critical_normal_inflight_processed_created_delta_threshold
  alarm_warning_bulk_inflight_processed_created_delta_threshold      = local.environment.alarms.thresholds.alarm_warning_bulk_inflight_processed_created_delta_threshold
  alarm_critical_bulk_inflight_processed_created_delta_threshold     = local.environment.alarms.thresholds.alarm_critical_bulk_inflight_processed_created_delta_threshold
  alarm_warning_bulk_processed_created_delta_threshold               = local.environment.alarms.thresholds.alarm_warning_bulk_processed_created_delta_threshold
  alarm_critical_bulk_processed_created_delta_threshold              = local.environment.alarms.thresholds.alarm_critical_bulk_processed_created_delta_threshold
  alarm_warning_priority_bulk_processed_created_delta_threshold      = local.environment.alarms.thresholds.alarm_warning_priority_bulk_processed_created_delta_threshold
  alarm_critical_priority_bulk_processed_created_delta_threshold     = local.environment.alarms.thresholds.alarm_critical_priority_bulk_processed_created_delta_threshold
  alarm_warning_normal_bulk_processed_created_delta_threshold        = local.environment.alarms.thresholds.alarm_warning_normal_bulk_processed_created_delta_threshold
  alarm_critical_normal_bulk_processed_created_delta_threshold       = local.environment.alarms.thresholds.alarm_critical_normal_bulk_processed_created_delta_threshold
  alarm_warning_bulk_bulk_processed_created_delta_threshold          = local.environment.alarms.thresholds.alarm_warning_bulk_bulk_processed_created_delta_threshold
  alarm_critical_bulk_bulk_processed_created_delta_threshold         = local.environment.alarms.thresholds.alarm_critical_bulk_bulk_processed_created_delta_threshold
  alarm_critical_expired_inflights_threshold                         = local.environment.alarms.thresholds.alarm_critical_expired_inflights_threshold

  # Slack Configuration
  cloudwatch_opsgenie_alarm_webhook = local.environment.alarms.slack.cloudwatch_opsgenie_alarm_webhook
  cloudwatch_slack_webhook_warning_topic = local.environment.alarms.slack.cloudwatch_slack_webhook_warning_topic
  cloudwatch_slack_webhook_critical_topic = local.environment.alarms.slack.cloudwatch_slack_webhook_critical_topic
  cloudwatch_slack_webhook_general_topic = local.environment.alarms.slack.cloudwatch_slack_webhook_general_topic
  slack_channel_warning_topic = local.environment.alarms.slack.slack_channel_warning_topic
  slack_channel_critical_topic = local.environment.alarms.slack.slack_channel_critical_topic
  slack_channel_general_topic = local.environment.alarms.slack.slack_channel_general_topic
  # Prevents repeated creation of the Slack lambdas if already existing.
  # This is capitalized because a module is expecting this format.
  RECREATE_MISSING_LAMBDA_PACKAGE = local.environment.alarms.slack.RECREATE_MISSING_LAMBDA_PACKAGE

  # SQS Configuration
  sqs_region = local.environment.sqs.sqs_region  
  sqs_priority_db_tasks_queue_name = local.environment.sqs.sqs_priority_db_tasks_queue_name
  sqs_normal_db_tasks_queue_name = local.environment.sqs.sqs_normal_db_tasks_queue_name
  sqs_bulk_db_tasks_queue_name = local.environment.sqs.sqs_bulk_db_tasks_queue_name

  # SNS Configuration
  sns_monthly_spend_limit = local.environment.sns.sns_monthly_spend_limit
  sns_monthly_spend_limit_us_west_2 = local.environment.sns.sns_monthly_spend_limit_us_west_2

  # WAF Configuration
  waf_secret = local.environment.waf.waf_secret
  non_api_waf_rate_limit = local.environment.waf.non_api_waf_rate_limit
  api_waf_rate_limit = local.environment.waf.api_waf_rate_limit
  sign_in_waf_rate_limit = local.environment.waf.sign_in_waf_rate_limit  
  
  # API Configuration
  api_image_tag = local.environment.api-lambda.api_image_tag
  api_enable_new_relic = local.environment.api-lambda.api_enable_new_relic
  new_relic_license_key = local.environment.api-lambda.new_relic_license_key
  dangerous_salt = local.environment.api-lambda.dangerous_salt
  ff_cloudwatch_metrics_enabled = local.environment.api-lambda.ff_cloudwatch_metrics_enabled
  redis_enabled = local.environment.api-lambda.redis_enabled
  new_relic_app_name = local.environment.api-lambda.new_relic_app_name
  new_relic_distribution_tracing_enabled = local.environment.api-lambda.new_relic_distribution_tracing_enabled
  notification_queue_prefix = local.environment.api-lambda.notification_queue_prefix  
  low_demand_min_concurrency = local.environment.api-lambda.performance.low_demand_min_concurrency
  low_demand_max_concurrency = local.environment.api-lambda.performance.low_demand_max_concurrency
  high_demand_min_concurrency = local.environment.api-lambda.performance.high_demand_min_concurrency
  high_demand_max_concurrency = local.environment.api-lambda.performance.high_demand_max_concurrency

  # RDS Configuration
  rds_cluster_password = local.environment.rds.rds_cluster_password
  app_db_user = local.environment.rds.app_db_user
  app_db_user_password = local.environment.rds.app_db_user_password
  dbtools_password = local.environment.rds.dbtools_password
  rds_instance_count = local.environment.rds.performance.rds_instance_count
  rds_instance_type = local.environment.rds.performance.rds_instance_type

  # Elasticache (Redis) Configuration
  elasticache_node_count                 = local.environment.elasticache.performance.elasticache_node_count
  elasticache_node_number_cache_clusters = local.environment.elasticache.performance.elasticache_node_number_cache_clusters
  elasticache_node_type                  = local.environment.elasticache.performance.elasticache_node_type

  #EKS Configuration
  eks_cluster_name = local.environment.eks.eks_cluster_name
  eks_cluster_version = local.environment.eks.eks_cluster_version
  eks_addon_coredns_version = local.environment.eks.eks_addon_coredns_version
  eks_addon_kube_proxy_version = local.environment.eks.eks_addon_kube_proxy_version
  eks_addon_vpc_cni_version = local.environment.eks.eks_addon_vpc_cni_version
  eks_node_ami_version = local.environment.eks.eks_node_ami_version

  primary_worker_desired_size = local.environment.eks.performance.primary_worker_desired_size
  primary_worker_instance_types = local.environment.eks.performance.primary_worker_instance_types
  primary_worker_max_size = local.environment.eks.performance.primary_worker_max_size
  primary_worker_min_size = local.environment.eks.performance.primary_worker_min_size

  # SES Receiving Emails Configuration
  celery_queue_prefix = local.environment.ses.celery_queue_prefix
  gc_notify_service_email = local.environment.ses.gc_notify_service_email  
  
  # Heartbeat Configuration
  heartbeat_api_key = local.environment.heartbeat.heartbeat_api_key
  heartbeat_template_id = local.environment.heartbeat.heartbeat_template_id
  schedule_expression = local.environment.heartbeat.schedule_expression

  # Google CIDR Lambda Configuration
  google_cidr_schedule_expression = local.environment.google-cidr.google_cidr_schedule_expression

  # Blazer Configuration
  blazer_image_tag                  = local.environment.blazer.blazer_image_tag
  notify_o11y_google_oauth_client_id = local.environment.blazer.notify_o11y_google_oauth_client_id
  notify_o11y_google_oauth_client_secret = local.environment.blazer.notify_o11y_google_oauth_client_secret

  # Performance Test
  perf_test_domain = local.environment.performance-test.perf_test_domain
  perf_test_phone_number = local.environment.performance-test.perf_test_phone_number
  perf_test_email = local.environment.performance-test.perf_test_email
  perf_test_auth_header = local.environment.performance-test.perf_test_auth_header
  aws_pinpoint_region       = local.environment.performance-test.perf_test_auth_header
  billing_tag_key                             = local.environment.performance-test.billing_tag_key
  perf_test_schedule_expression               = local.environment.performance-test.perf_test_schedule_expression
  perf_test_aws_s3_bucket                     = local.environment.performance-test.perf_test_aws_s3_bucket
  perf_test_csv_directory_path                = local.environment.performance-test.perf_test_csv_directory_path
  perf_test_sms_template_id                   = local.environment.performance-test.perf_test_sms_template_id
  perf_test_bulk_email_template_id            = local.environment.performance-test.perf_test_bulk_email_template_id
  perf_test_email_template_id                 = local.environment.performance-test.perf_test_email_template_id
  perf_test_email_with_attachment_template_id = local.environment.performance-test.perf_test_email_with_attachment_template_id
  perf_test_email_with_link_template_id       = local.environment.performance-test.perf_test_email_with_link_template_id
 
  
}

terraform {

  before_hook "checkTFVars" {
    commands     = ["apply", "plan"]
    execute      = ["${get_parent_terragrunt_dir()}/scripts/checkVarFile.sh", "${get_parent_terragrunt_dir()}"]
    run_on_error = true
  }

  after_hook "syncTFVars" {
    commands     = ["apply"]
    execute      = ["${get_parent_terragrunt_dir()}/scripts/syncVarFile.sh", "${get_parent_terragrunt_dir()}"]
    run_on_error = false
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
    role_arn = "arn:aws:iam::${local.environment.account.staging_account_id}:role/${local.environment.global.env}_dns_manager_role"
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
    bucket              = "notification-canada-ca-${local.environment.global.env}-tf"
    dynamodb_table      = "terraform-state-lock-dynamo"
    region              = "ca-central-1"
    key                 = "${path_relative_to_include()}/terraform.tfstate"
    s3_bucket_tags      = { CostCenter : "notification-canada-ca-${local.environment.global.env}" }
    dynamodb_table_tags = { CostCenter : "notification-canada-ca-${local.environment.global.env}" }
  }
}

