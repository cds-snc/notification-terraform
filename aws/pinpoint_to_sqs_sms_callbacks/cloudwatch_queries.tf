resource "aws_cloudwatch_query_definition" "pinpoint-logs" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "SMS (Pinpoint) / Logs"

  log_group_names = [
    aws_cloudwatch_log_group.pinpoint_deliveries.name
  ]

  query_string = <<QUERY
fields @timestamp, destinationPhoneNumber, messageStatus, messageStatusDescription, @logStream
| filter isFinal
| sort @timestamp desc
| limit 100
QUERY
}
