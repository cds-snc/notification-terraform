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

resource "aws_cloudwatch_query_definition" "celery-errors" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "Celery errors"

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

