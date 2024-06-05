################################ CELERY FOLDER ################################

resource "aws_cloudwatch_query_definition" "celery-errors" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "Celery / Errors"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^celery/
| filter @message like /ERROR\/.*Worker/
| sort @timestamp desc
| limit 20
QUERY
}

resource "aws_cloudwatch_query_definition" "celery-filter-by-job" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "Celery / Filter by job"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.labels.app as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.labels.app like /^celery/
| filter @message like /0d58e195-d6ae-4fe3-aa73-064ff106972b/
| sort @timestamp desc
| limit 20
QUERY
}

resource "aws_cloudwatch_query_definition" "celery-filter-by-notification-id" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "Celery / Filter by notification id"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^celery/
| filter @message like /notification_id/
| sort @timestamp desc
| limit 20
QUERY
}

resource "aws_cloudwatch_query_definition" "celery-memory-usage-by-pod" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "Celery / Memory Usage By Pod"

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
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "Celery / Pods over CPU Limit"

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
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "Celery / Queues"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.labels.app as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.labels.app like /^celery/
| filter @message like /queue for delivery/
| sort @timestamp desc
| limit 20
QUERY
}

resource "aws_cloudwatch_query_definition" "celery-starts" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "Celery / Starts"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.labels.app as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^celery/
| filter @message like /Notify config/
| sort @timestamp desc
| stats count
QUERY
}

resource "aws_cloudwatch_query_definition" "celery-worker-exited-normally" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "Celery / Worker exited normally"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^celery/
| filter @message like /Warm shutdown/
| sort @timestamp desc
QUERY
}

resource "aws_cloudwatch_query_definition" "celery-worker-exited-prematurely" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "Celery / Worker exited prematurely"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^celery/
| filter @message like /Task handler raised error: WorkerLostError\('Worker exited prematurely/
| sort @timestamp desc
QUERY
}

resource "aws_cloudwatch_query_definition" "celery-worker-exits-cold-vs-warm" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "Celery / Worker exits, cold vs warm"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^celery/
| parse "Warm shutdown" as @warm
| parse "Worker exited prematurely" as @cold
| filter ispresent(@warm) or ispresent(@cold)
| stats count(@warm) as warm, count(@cold) as cold by bin(15m)
QUERY
}

resource "aws_cloudwatch_query_definition" "retry-attemps-by-duration" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "Celery / Retry attempts by duration"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^celery/
| filter @message like /Retry in/
| parse @message /Retry in (?<retry_duration>\d+s)/
| stats count() by retry_duration
QUERY
}

################################ UNSORTED YET #################################

resource "aws_cloudwatch_query_definition" "admin-api-50X-errors" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "ADMIN & API - 50X errors"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /admin|api/
| filter @message like /HTTP\/\d+\.\d+\\" 50\d/
| sort @timestamp desc
| limit 20
QUERY
}

resource "aws_cloudwatch_query_definition" "bounce-rate-critical" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "Critical bounces"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /admin|api/
| filter @message like "critical bounce rate threshold of 10"
| sort @timestamp desc
| limit 20
QUERY
}

resource "aws_cloudwatch_query_definition" "bounce-rate-warning" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "Warning bounces"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /admin|api/
| filter @message like "warning bounce rate threshold of 5"
| sort @timestamp desc
| limit 20
QUERY
}

resource "aws_cloudwatch_query_definition" "bounce-rate-warnings-and-criticals" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "Bounce warnings and criticals grouped by type"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, @service_id, @bounce_type
| filter kubernetes.container_name like /^celery/
| filter @message like /bounce rate threshold of/
| parse @message "Service: * has met or exceeded a * bounce rate" as @service_id, @bounce_type
| stats count(*) by @service_id, @bounce_type
| limit 100
QUERY
}

resource "aws_cloudwatch_query_definition" "callback-failures-by-service" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "Count of callbacks that exceeded MaxRetries by service"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.container_name like /^celery/
| filter @message like /send_delivery_status_to_service has retried the max num of times for callback url/
| parse @message 'Retry: send_delivery_status_to_service has retried the max num of times for callback url * and notification_id: * for service: *' as @callback_url, @notification_id, @service_id
| sort @timestamp desc
| stats count(@service_id) by @service_id
| limit 10000
QUERY
}
