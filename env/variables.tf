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

variable "scan_files_account_id" {
  type      = string
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

variable "lambda_new_relic_app_name" {
  type = string
}

variable "lambda_new_relic_distribution_tracing_enabled" {
  type = string
}

variable "lambda_new_relic_handler" {
  type        = string
  description = "The actual Lambda handler function that New Relic wrapper should invoke"
}

variable "lambda_new_relic_extension_enabled" {
  type        = string
  description = "Enable the New Relic Lambda extension for telemetry shipping"
}

variable "lambda_new_relic_extension_logs_enabled" {
  type        = string
  description = "Enable sending Lambda execution logs through the New Relic extension"
}

variable "lambda_new_relic_extension_send_function_logs" {
  type        = string
  description = "Allow the New Relic extension to forward function stdout/stderr logs"
}

variable "lambda_new_relic_config_file" {
  type        = string
  description = "Path to the New Relic configuration file in the Lambda container"
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

variable "blazer_rds_version" {
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

variable "elasticache_cache_ops_node_type" {
  type = string
}

variable "elasticache_cache_ops_node_count" {
  type = number
}

variable "elasticache_admin_cache_node_count" {
  type = number
}

variable "elasticache_admin_cache_node_type" {
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

variable "new_relic_aws_account_id" {
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

variable "sentinel_sre_aws_account_id" {
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

variable "heartbeat_schedule_expression" {
  type = string
}

variable "system_status_schedule_expression" {
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

variable "app_db_database_name" {
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

variable "ff_batch_insertion" {
  type = string
}

variable "ff_cloudwatch_metrics_enabled" {
  type = string
}

variable "ff_redis_batch_saving" {
  type = string
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

variable "perf_test_api_key" {
  type      = string
  sensitive = true
}

variable "perf_test_slack_webhook" {
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

variable "perf_test_sms_template_id_one_var" {
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

variable "perf_test_email_template_id_one_var" {
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

variable "manifest_admin_client_secret" {
  type      = string
  sensitive = true
}

variable "manifest_auth_tokens" {
  type      = string
  sensitive = true
}

variable "manifest_document_download_api_key" {
  type      = string
  sensitive = true
}

variable "manifest_aws_route53_zone" {
  type      = string
  sensitive = true
}

variable "manifest_aws_ses_access_key" {
  type      = string
  sensitive = true
}

variable "manifest_aws_ses_secret_key" {
  type      = string
  sensitive = true
}

variable "manifest_dangerous_salt" {
  type      = string
  sensitive = true
}

variable "manifest_debug_key" {
  type      = string
  sensitive = true
}

variable "manifest_fresh_desk_product_id" {
  type      = string
  sensitive = true
}

variable "manifest_fresh_desk_api_key" {
  type      = string
  sensitive = true
}

variable "manifest_gc_articles_api_auth_username" {
  type      = string
  sensitive = true
}

variable "manifest_gc_articles_api_auth_password" {
  type      = string
  sensitive = true
}

variable "manifest_mixpanel_project_token" {
  type      = string
  sensitive = true
}

variable "manifest_new_relic_license_key" {
  type      = string
  sensitive = true
}

variable "manifest_new_relic_account_id" {
  type      = string
  sensitive = true
}

variable "manifest_new_relic_api_key" {
  type      = string
  sensitive = true
}

variable "manifest_crm_github_personal_access_token" {
  type      = string
  sensitive = true
}

variable "manifest_salesforce_username" {
  type      = string
  sensitive = true
}

variable "manifest_salesforce_password" {
  type      = string
  sensitive = true
}

variable "manifest_salesforce_security_token" {
  type      = string
  sensitive = true
}

variable "manifest_salesforce_client_privatekey" {
  type      = string
  sensitive = true
}

variable "manifest_salesforce_engagement_product_id" {
  type      = string
  sensitive = true
}

variable "manifest_salesforce_engagement_record_type" {
  type      = string
  sensitive = true
}

variable "manifest_salesforce_engagement_standard_pricebook_id" {
  type      = string
  sensitive = true
}

variable "manifest_salesforce_generic_account_id" {
  type      = string
  sensitive = true
}

variable "manifest_secret_key" {
  type      = string
  sensitive = true
}

variable "manifest_sendgrid_api_key" {
  type      = string
  sensitive = true
}

variable "manifest_waf_secret" {
  type      = string
  sensitive = true
}

variable "manifest_zendesk_api_key" {
  type      = string
  sensitive = true
}

variable "manifest_zendesk_sell_api_key" {
  type      = string
  sensitive = true
}

variable "manifest_sre_client_secret" {
  type      = string
  sensitive = true
}

variable "manifest_cache_clear_client_secret" {
  type      = string
  sensitive = true
}

variable "manifest_aws_pinpoint_sc_pool_id" {
  type      = string
  sensitive = true
}

variable "manifest_aws_pinpoint_sc_template_ids" {
  type      = string
  sensitive = true
}

variable "manifest_aws_pinpoint_default_pool_id" {
  type      = string
  sensitive = true
}

variable "manifest_cypress_user_pw_secret" {
  type      = string
  sensitive = true
}

variable "manifest_cypress_auth_client_secret" {
  type      = string
  sensitive = true
}

variable "manifest_smoke_api_key" {
  type      = string
  default   = "changeme"
  sensitive = true
}

variable "manifest_smoke_admin_client_secret" {
  type      = string
  default   = "changeme"
  sensitive = true
}

variable "manifest_pr_bot_github_token" {
  type      = string
  sensitive = true
  default   = "stagingonly"
}

variable "github_app_id" {
  type      = string
  sensitive = true
}

variable "github_app_installation_id" {
  type      = string
  sensitive = true
}

variable "github_app_pem_file" {
  type      = string
  sensitive = true
}

variable "notify_dev_slack_webhook" {
  type      = string
  sensitive = true
  default   = "prodonly"
}

variable "openai_api_key" {
  type      = string
  sensitive = true
  default   = "prodonly"
}

variable "op_service_account_token" {
  type      = string
  sensitive = true
}

variable "aws_access_key_id" {
  type      = string
  sensitive = true
}

variable "aws_secret_access_key" {
  type      = string
  sensitive = true
}

variable "admin_cypress_env_json" {
  type      = string
  sensitive = true
  default   = "c3RhZ2luZ29ubHkK"
}

variable "admin_pr_review_env_security_group_ids" {
  type      = string
  sensitive = true
  default   = "stagingonly"
}

variable "admin_pr_review_env_subnet_ids" {
  type      = string
  sensitive = true
  default   = "stagingonly"
}

variable "admin_a11y_tracker_key" {
  type      = string
  sensitive = true
  default   = "prodonly"
}

variable "ipv4_maxmind_license_key" {
  type      = string
  sensitive = true
  default   = "prodonly"
}

variable "github_manifests_workflow_token" {
  type      = string
  sensitive = true
  default   = "prodonly"
}

variable "manifest_docker_hub_username" {
  type      = string
  sensitive = true
}

variable "manifest_docker_hub_pat" {
  type      = string
  sensitive = true
}

variable "elasticache_use_valkey" {
  type    = bool
  default = false
}

variable "sqs_max_message_size" {
  type    = number
  default = 1048576 # 1 MB
}
variable "new_relic_user_id" {
  type      = string
  sensitive = true
}