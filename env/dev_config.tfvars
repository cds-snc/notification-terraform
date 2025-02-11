## GENERAL
env                  = "dev"
account_budget_limit = 5000
region               = "ca-central-1"
billing_tag_value    = "notification-canada-ca-dev"
billing_tag_key      = "CostCenter"

## EKS     
primary_worker_desired_size     = 5
primary_worker_instance_types   = ["m5.large"]
secondary_worker_instance_types = ["m5.large"]
node_upgrade                    = false
force_upgrade                   = true
primary_worker_max_size         = 7
primary_worker_min_size         = 1
eks_cluster_name                = "notification-canada-ca-dev-eks-cluster"
eks_cluster_version             = "1.31"
eks_addon_coredns_version       = "v1.11.3-eksbuild.1"
eks_addon_kube_proxy_version    = "v1.31.0-eksbuild.5"
eks_addon_vpc_cni_version       = "v1.18.5-eksbuild.1"
eks_addon_ebs_driver_version    = "v1.35.0-eksbuild.1"
eks_node_ami_version            = "1.31.4-20250203"
eks_karpenter_ami_id            = "ami-055ae9cc5270ab08c"
non_api_waf_rate_limit          = 500
api_waf_rate_limit              = 30000
sign_in_waf_rate_limit          = 100
celery_queue_prefix             = "eks-notification-canada-ca"
notify_k8s_namespace            = "notification-canada-ca"

# lambda-api
api_image_tag                          = "latest"
redis_enabled                          = "1"
low_demand_min_concurrency             = 1
low_demand_max_concurrency             = 5
high_demand_min_concurrency            = 1
high_demand_max_concurrency            = 10
new_relic_app_name                     = "notification-lambda-api-dev"
new_relic_distribution_tracing_enabled = "true"
notification_queue_prefix              = "eks-notification-canada-ca"

# ENVIRONMENT
enable_new_relic           = true
create_cbs_bucket          = true
force_destroy_s3           = true
force_delete_ecr           = true
force_destroy_athena       = true
bootstrap                  = true
enable_sentinel_forwarding = true
enable_delete_protection   = false
api_enable_new_relic       = false
cloudwatch_enabled         = true
recovery                   = true
aws_xray_sdk_enabled       = true

## DNS
alt_domain                 = "alpha.dev.notification.cdssandbox.xyz"
domain                     = "dev.notification.cdssandbox.xyz"
base_domain                = "dev.notification.cdssandbox.xyz"
perf_test_domain           = "https://api-k8s.dev.notification.cdssandbox.xyz"
ses_custom_sending_domains = ["custom-sending-domain.dev.notification.cdssandbox.xyz"]

## LOGGING
log_retention_period_days           = 14
sensitive_log_retention_period_days = 14

## VPC
vpc_cidr_block = "10.0.0.0/16"

## ELASTICACHE
elasticache_node_count                 = 1
elasticache_node_number_cache_clusters = 3
elasticache_node_type                  = "cache.t3.micro"

## SLACK INTEGRATION
slack_channel_warning_topic  = "notification-dev-ops"
slack_channel_critical_topic = "notification-dev-ops"
slack_channel_general_topic  = "notification-dev-ops"

## MONITORING
athena_workgroup_name             = "dev"
cloudwatch_opsgenie_alarm_webhook = ""
aws_config_recorder_name          = "aws-controltower-BaselineConfigRecorder"

## HEARTBEAT
heartbeat_sms_number = "+16135550123"
schedule_expression  = "rate(1 minute)"

## LAMBDA GOOGLE CIDR
google_cidr_schedule_expression = "rate(1 day)"

## RDS
rds_instance_count = 3
rds_instance_type  = "db.t3.medium"
rds_database_name  = "NotificationCanadaCastaging"
rds_version        = "15.5"


## NOTIFY-API/CELERY               
RECREATE_MISSING_LAMBDA_PACKAGE = "false"
ff_batch_insertion              = "true"
ff_cloudwatch_metrics_enabled   = "true"
ff_redis_batch_saving           = "true"

## SES_RECEIVING_EMAILS
notify_sending_domain   = "staging.notification.cdssandbox.xyz"
sqs_region              = "ca-central-1"
gc_notify_service_email = "gc.notify.notification.gc@staging.notification.cdssandbox.xyz"

## PERF TEST
aws_pinpoint_region          = "ca-central-1"
perf_test_phone_number       = "16135550123"
perf_test_email              = "success@simulator.amazonses.com"
perf_schedule_expression     = "cron(0 0 * * ? *)"
perf_test_aws_s3_bucket      = "notify-performance-test-results-dev"
perf_test_csv_directory_path = "/tmp/notify_performance_test"

## SYSTEM STATUS
system_status_api_url     = "https://api.dev.notification.cdssandbox.xyz"
system_status_bucket_name = "notification-canada-ca-dev-system-status"
system_status_admin_url   = "https://dev.notification.cdssandbox.xyz"

## COMMON
sns_monthly_spend_limit                                            = 100
sns_monthly_spend_limit_us_west_2                                  = 1
alarm_warning_document_download_bucket_size_gb                     = 0.5
alarm_warning_inflight_processed_created_delta_threshold           = 100
alarm_critical_inflight_processed_created_delta_threshold          = 200
alarm_warning_priority_inflight_processed_created_delta_threshold  = 100
alarm_critical_priority_inflight_processed_created_delta_threshold = 300
alarm_warning_normal_inflight_processed_created_delta_threshold    = 100
alarm_critical_normal_inflight_processed_created_delta_threshold   = 200
alarm_warning_bulk_inflight_processed_created_delta_threshold      = 100
alarm_critical_bulk_inflight_processed_created_delta_threshold     = 200
alarm_warning_bulk_processed_created_delta_threshold               = 5000
alarm_critical_bulk_processed_created_delta_threshold              = 10000
alarm_warning_priority_bulk_processed_created_delta_threshold      = 5000
alarm_critical_priority_bulk_processed_created_delta_threshold     = 10000
alarm_warning_normal_bulk_processed_created_delta_threshold        = 5000
alarm_critical_normal_bulk_processed_created_delta_threshold       = 10000
alarm_warning_bulk_bulk_processed_created_delta_threshold          = 5000
alarm_critical_bulk_bulk_processed_created_delta_threshold         = 10000
alarm_critical_expired_inflights_threshold                         = 10
sqs_visibility_timeout_default                                     = 310
sqs_visibility_timeout_priority_high                               = 26
sqs_priority_db_tasks_queue_name                                   = "priority-database-tasks.fifo"
sqs_normal_db_tasks_queue_name                                     = "normal-database-tasks"
sqs_bulk_db_tasks_queue_name                                       = "bulk-database-tasks"
sqs_db_tasks_queue_name                                            = "database-tasks"
sqs_throttled_sms_queue_name                                       = "send-throttled-sms-tasks"
sqs_bulk_queue_name                                                = "bulk-tasks"
sqs_priority_queue_name                                            = "priority-tasks"
sqs_send_email_high_queue_name                                     = "send-email-high"
sqs_send_email_medium_queue_name                                   = "send-email-medium"
sqs_send_email_low_queue_name                                      = "send-email-low"
sqs_send_sms_high_queue_name                                       = "send-sms-high"
sqs_send_sms_medium_queue_name                                     = "send-sms-medium"
sqs_send_sms_low_queue_name                                        = "send-sms-low"

# RANDOM DOCKER TAGS
system_status_docker_tag                 = "bootstrap"
heartbeat_docker_tag                     = "bootstrap"
google_cidr_docker_tag                   = "bootstrap"
sns_to_sqs_sms_callbacks_docker_tag      = "bootstrap"
ses_to_sqs_callbacks_docker_tag          = "bootstrap"
ses_receiving_emails_docker_tag          = "bootstrap"
pinpoint_to_sqs_sms_callbacks_docker_tag = "bootstrap"

## BLAZER
blazer_image_tag   = "latest"
blazer_rds_version = "15.10"
