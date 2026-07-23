locals {
  celery_name            = "notify-celery"
  admin_name             = "notify-admin"
  api_name               = "notify-api"
  document_download_name = "notify-document-download"
  documentation_name     = "notify-documentation"

}

################################ CELERY FOLDER ################################

resource "aws_cloudwatch_query_definition" "celery-errors" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Celery / Errors"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.celery_name}/
| filter @message like /ERROR\/.*Worker/ or @message like /ERROR\/MainProcess/
| sort @timestamp desc
| limit 20
QUERY
}

resource "aws_cloudwatch_query_definition" "celery-filter-by-job" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Celery / Filter by job"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.labels.app as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.labels.app like /^${local.celery_name}/
| filter @message like /0d58e195-d6ae-4fe3-aa73-064ff106972b/
| sort @timestamp desc
| limit 20
QUERY
}

resource "aws_cloudwatch_query_definition" "celery-filter-by-notification-id" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Celery / Filter by notification id"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.celery_name}/
| filter @message like /notification_id/
| sort @timestamp desc
| limit 20
QUERY
}

resource "aws_cloudwatch_query_definition" "celery-memory-usage-by-pod" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Celery / Memory Usage By Pod"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, @message, @logStream, @log, PodName, kubernetes.pod_name, pod_memory_usage
| filter kubernetes.pod_name = "<pod-name>"
| sort @timestamp desc
| stats avg(pod_memory_utilization_over_pod_limit) by bin(30s)
QUERY
}

resource "aws_cloudwatch_query_definition" "celery-pods-over-cpu-limit" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Celery / Pods over CPU Limit"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, @message, @logStream, @log, PodName, kubernetes.pod_name, pod_memory_usage
| filter kubernetes.pod_name = "<pod-name>"
| sort @timestamp desc
| stats avg(pod_cpu_utilization_over_pod_limit) by bin(30s)
QUERY
}

resource "aws_cloudwatch_query_definition" "celery-queues" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Celery / Queues"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.labels.app as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.labels.app like /^${local.celery_name}/
| filter @message like /queue for delivery/
| sort @timestamp desc
| limit 20
QUERY
}

resource "aws_cloudwatch_query_definition" "celery-starts" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Celery / Starts"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.labels.app as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.celery_name}/
| filter @message like /Notify config/
| sort @timestamp desc
| stats count
QUERY
}

resource "aws_cloudwatch_query_definition" "celery-worker-exited-normally" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Celery / Worker exited normally"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.celery_name}/
| filter @message like /Warm shutdown/
| sort @timestamp desc
QUERY
}

resource "aws_cloudwatch_query_definition" "celery-worker-exited-prematurely" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Celery / Worker exited prematurely"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.celery_name}/
| filter @message like /Task handler raised error: WorkerLostError\('Worker exited prematurely/
| sort @timestamp desc
QUERY
}

resource "aws_cloudwatch_query_definition" "celery-worker-exits-cold-vs-warm" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Celery / Worker exits, cold vs warm"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.celery_name}/
| parse "Warm shutdown" as @warm
| parse "Worker exited prematurely" as @cold
| parse "worker shutdown:" as @shutdown
| filter ispresent(@warm) or ispresent(@cold) or ispresent(@shutdown)
| stats count(@warm) as warm, count(@cold) as cold, count(@shutdown) as shutdown by bin(15m)
QUERY
}

resource "aws_cloudwatch_query_definition" "retry-attemps-by-duration" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Celery / Retry attempts by duration"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.celery_name}/
| filter @message like /Retry in/
| parse @message /Retry in (?<retry_duration>\d+s)/
| stats count() by retry_duration
QUERY
}

resource "aws_cloudwatch_query_definition" "celery-count-known-errors" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Celery / Count of known errors"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.celery_name}/
| filter @message like /CELERY_KNOWN_ERROR/
| parse @message /CELERY_KNOWN_ERROR::(?<error>[a-zA-Z_]+)/
| stats count(*) as total by error
| sort total desc
| limit 20
QUERY
}

resource "aws_cloudwatch_query_definition" "celery-unknown-errors" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Celery / Unknown errors"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.celery_name}/
| filter @message like /CELERY_UNKNOWN_ERROR/
| limit 200
QUERY
}

resource "aws_cloudwatch_query_definition" "celery-notifications-timeouts" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Celery / Notifications timeout"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.celery_name}/
| filter @message like /Timeout period reached for/
| parse @message "*stderr F [*,*: INFO/ForkPoolWorker-*] Timeout period reached for * notifications*" as @ignore, @date, @time_ms, @worker_id, @notification_count, @ignore2
| sort @timestamp desc
| display @date, @notification_count
| limit 200
QUERY
}

################################ UNSORTED YET #################################

resource "aws_cloudwatch_query_definition" "admin-50X-errors" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Admin / 50X errors"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /${local.admin_name}/
| filter @message like /HTTP\/\d+\.\d+\\" 50\d/
| sort @timestamp desc
| limit 20
QUERY
}

resource "aws_cloudwatch_query_definition" "admin-svc-audit-removed-users" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Admin / Service audit - removed users"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /notify-admin/
| filter @message like /is removing user/
| parse @message "User * is removing user: * from service: *" as @admin_user, @removed_user, @service
| sort @timestamp desc
| display @timestamp, @admin_user, @removed_user, @service, log
| limit 20

QUERY
}

resource "aws_cloudwatch_query_definition" "admin-slow-dashboards" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Admin / Slow Dashboards"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /notify-admin/
| filter @message like /MING: Total get_dashboard_partial/ and @message like 'dashboard.json'
| parse @message "TIMING: Total get_dashboard_partials execution took *ms [Request details: time_taken: *ms full_path: '/services/*/dashboard.json?'" @response_time, @discard, @service_id
| stats avg(@response_time) as avg_response_time, max(@response_time) as max_response_time by @service_id
| sort max_response_time desc
| limit 100

QUERY
}

resource "aws_cloudwatch_query_definition" "api-50X-errors" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "API / 50X errors"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /${local.api_name}/
| filter @message like /HTTP\/\d+\.\d+\\" 50\d/
| sort @timestamp desc
| limit 20
QUERY
}

resource "aws_cloudwatch_query_definition" "api-gunicorn-total-time" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "API / GUnicorn total running time"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
filter @message like /Total gunicorn API running time/
| parse @message /Total gunicorn API running time: (?<@gunicorn_time>.*?) seconds/
| order by @timestamp asc
| display @timestamp, @gunicorn_time
QUERY
}

resource "aws_cloudwatch_query_definition" "api-non-existent-domain-resolution-errors" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "API / Non-existent domain resolution errors"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
filter @message like /NXDOMAIN/
| limit 10000
QUERY
}

resource "aws_cloudwatch_query_definition" "api-non-existent-domain-resolution-errors-stats" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "API / Non-existent domain resolution error stats"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, @message, @logStream, @log
| filter @message like /NXDOMAIN/
| parse @message /IN (?<@domain>.*?). udp/
| stats count(*) as Total by @domain
| sort Total desc, @domain 
| limit 1000
QUERY
}

resource "aws_cloudwatch_query_definition" "api-non-existent-domain-resolution-errors-stats-by-5-minutes" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "API / Non-existent domain resolution errors by 5 minutes"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, @message, @logStream, @log
| filter @message like /NXDOMAIN/
| parse @message /IN (?<@domain>.*?). udp/
| stats count(*) as Total by @domain, bin(5m) as Timerange
| sort Total desc, @domain asc, Timerange asc
| display @domain, Total, Timerange
| limit 1000
QUERY
}

resource "aws_cloudwatch_query_definition" "bounce-rate-critical" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Bounces / Critical bounces"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.celery_name}-email-send-*/
| filter @message like "critical bounce rate threshold of 10"
| sort @timestamp desc
| limit 20
QUERY
}

resource "aws_cloudwatch_query_definition" "bounce-rate-warning" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Bounces / Warning bounces"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.celery_name}-email-send-*/
| filter @message like "warning bounce rate threshold of 5"
| sort @timestamp desc
| limit 20
QUERY
}

resource "aws_cloudwatch_query_definition" "bounce-rate-warnings-and-criticals" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Bounces / Bounce warnings and criticals grouped by type"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, @service_id, @bounce_type
| filter kubernetes.container_name like /^${local.celery_name}-email-send-*/
| filter @message like /bounce rate threshold of/
| parse @message "Service: * has met or exceeded a * bounce rate" as @service_id, @bounce_type
| stats count(*) by @service_id, @bounce_type
| limit 100
QUERY
}

resource "aws_cloudwatch_query_definition" "callback-errors-by-url" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Callbacks / Callback errors by URL"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.celery_name}/
| filter @message like /send_delivery_status_to_service request failed for notification_id/
| parse log "to url: * service: * exc:" as @url, @service_id
| stats count() as failed_callbacks by @url, @service_id
| order by failed_callbacks desc
QUERY
}

resource "aws_cloudwatch_query_definition" "callback-max-retry-failures-by-service" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Callbacks / Callbacks that exceeded MaxRetries by service"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, @service_id, @callback_url, @notification_id
| filter kubernetes.container_name like /^${local.celery_name}/
| filter @message like /send_delivery_status_to_service has retried the max num of times for callback url/
| parse @message 'Retry: send_delivery_status_to_service has retried the max num of times for callback url * and notification_id: * service: *' as @callback_url, @notification_id, @service_id
| sort @timestamp desc
| stats count(@service_id) by @service_id, bin(30m)
| limit 10000
QUERY
}

resource "aws_cloudwatch_query_definition" "callback-failures" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Callbacks / Callback errors by notification_id"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, @notification_id, @url, @error
| filter kubernetes.container_name like /^${local.celery_name}/
| filter @message like /send_delivery_status_to_service request failed for notification_id:/
| parse @message 'send_delivery_status_to_service request failed for notification_id: * and url: * service: * exc: *' as @notification_id, @url, @service_id, @error
| limit 10000
QUERY
}

### API Queries

resource "aws_cloudwatch_query_definition" "api-errors" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "API / API errors"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.api_name}/
| filter log like /rror/
| sort @timestamp desc
| limit 20
QUERY
}

resource "aws_cloudwatch_query_definition" "services-over-daily-rate-limit" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "API / Services going over daily rate limits"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.api_name}/
| filter log like /has been rate limited/
| parse log /service (?<service>.*?) has been rate limited for (?<limit_type>..........).*/
| stats count(*) by service, limit_type
QUERY
}

resource "aws_cloudwatch_query_definition" "api-504-timeouts" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "API / 504 timeouts grouped by hour"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.api_name}/
| filter log like /HTTP\/\d+\.\d+" 504/
| stats count() as error_count by bin(@timestamp, 1h)
| sort @timestamp desc
| limit 1000
QUERY
}

resource "aws_cloudwatch_query_definition" "api_response_code_counts" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "API / Response Code Counts"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, @logStream
| filter kubernetes.container_name like /^${local.api_name}/
| parse log /HTTP\/\d+\.\d+" (?<status>\d{3})/
| filter ispresent(status)
| stats count(*) by status
QUERY
}

resource "aws_cloudwatch_query_definition" "api_count_requests_by_minute" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "API / Requests By Minute"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.api_name}/
| parse log /(?<httpMethod>GET|POST|PUT|DELETE|PATCH) /
| filter ispresent(httpMethod)
| stats count(*) by httpMethod, bin(1m) as minute
| order by minute asc
| limit 100
QUERY
}

resource "aws_cloudwatch_query_definition" "get-trace-by-notification-id" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "API / Get Trace By Notification ID"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.api_name}/
| filter log like /d9cc47e6-b1a3-4c83-8d3c-ab40874307b1/
| sort @timestamp asc
| limit 100
QUERY
}

resource "aws_cloudwatch_query_definition" "api-sending-times-aggregate" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "API / API send times aggregate"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.api_name}/
| filter log like /time_taken/ and log like /Batch saving/
| parse log "time_taken: *ms" as duration
| parse log "full_path: '/v2/notifications/*'" as send_type
| parse log "template_id: '*'" as template_id
| sort @timestamp desc
| stats 
    count(*) as total_sends,
    sum(if(duration <= 400, 1, 0)) as requests_under_400ms,
    sum(if(duration > 400 and duration <= 1000, 1, 0)) as requests_under_1s,
    sum(if(duration > 1000, 1, 0)) as requests_over_1s,
    (sum(if(duration <= 400, 1, 0)) * 100.0 / count(*)) as percent_under_400ms,
    (sum(if(duration > 400 and duration <= 1000, 1, 0)) * 100.0 / count(*)) as percent_under_1s, 
    (sum(if(duration > 1000, 1, 0)) * 100.0 / count(*)) as percent_over_1s
| limit 20
QUERY
}

resource "aws_cloudwatch_query_definition" "api-slowest-sends" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "API / API slowest sends"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.api_name}/
| filter log like /time_taken/ and log like /Batch saving/
| parse log "time_taken: *ms" as duration
| parse log "full_path: '/v2/notifications/*'" as send_type
| parse log "template_id: '*'" as template_id
| sort duration desc
| limit 20
QUERY
}

resource "aws_cloudwatch_query_definition" "api_errors_by_ip_address" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "API / API error by IP address"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.api_name}/
| filter log like /HTTP\/\d+\.\d+" 50\d/
| parse log /^(?<ip>[\d.]+)/
| stats count() as total by ip
| order by total desc
| limit 1000
QUERY
}

resource "aws_cloudwatch_query_definition" "api_average_latency" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "API / Average Latency"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.api_name}/
| parse log "full_path: '*'" as resourcePath
| parse log "time_taken: *ms" as responseLatency
| filter ispresent(responseLatency)
| stats 
    count() as requests,
    avg(responseLatency) as avgLatency,
    pct(responseLatency, 95) as p95Latency,
    max(responseLatency) as maxLatency
    by resourcePath,
       if(responseLatency < 400, "under 400ms",
          if(responseLatency < 1000, "400ms - 1s", "over 1s")
       ) as latencyBucket
| sort avgLatency desc
QUERY
}

resource "aws_cloudwatch_query_definition" "api_concurrent_running_per_min" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "API / Concurrent API requests per min"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.api_name}/
| parse log /(?<httpMethod>GET|POST|PUT|DELETE|PATCH) (?<path>\/[^ ]*)/
| filter ispresent(httpMethod)
| stats count() as requests by bin(1m)
| sort requests desc
QUERY
}

resource "aws_cloudwatch_query_definition" "api_gunicorn_total_running_time" {
  provider = aws.core_services
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "API / Gunicorn total running time"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^${local.api_name}/
| filter log like /Total gunicorn API running time/
| parse log /Total gunicorn API running time: (?<@gunicorn_time>.*?) seconds/
| order by @timestamp asc
| display @timestamp, @gunicorn_time
QUERY
}
