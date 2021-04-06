resource "aws_cloudwatch_query_definition" "admin-api-500-errors" {
  name = "ADMIN & API - 500 errors"

  log_groups = [
    local.eks_application_log_group
  ]

  query = <<EOF
fields @timestamp, log, kubernetes.labels.app as app, kubernetes.pod_name as pod_name, @logStream
| filter kubernetes.labels.app like /admin|api/
| filter strcontains(@message, 'HTTP/1.1\" 500')
| sort @timestamp desc
| limit 20
EOF
}
