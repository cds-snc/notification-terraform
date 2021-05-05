resource "aws_cloudwatch_query_definition" "admin-api-50X-errors" {
  name = "ADMIN & API - 50X errors"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.labels.app as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.labels.app like /admin|api/
| filter @message like /HTTP\/\d+\.\d+\\" 50\d/
| sort @timestamp desc
| limit 20
QUERY
}

resource "aws_cloudwatch_query_definition" "celery-errors" {
  name = "Celery errors"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, kubernetes.labels.app as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.labels.app like /^celery/
| filter @message like /ERROR\/.*Worker/
| sort @timestamp desc
| limit 20
QUERY
}

resource "aws_cloudwatch_query_definition" "services-over-daily-rate-limit" {
  name = "Services going over daily rate limits"

  log_group_names = [
    local.eks_application_log_group
  ]

  query_string = <<QUERY
fields @timestamp, log, @logStream
| filter strcontains(@message, 'has been rate limited for daily use sent')
| sort @timestamp desc
| limit 20
QUERY
}
