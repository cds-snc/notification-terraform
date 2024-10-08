resource "aws_cloudwatch_query_definition" "pinpoint-carrier-dwell-times" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "SMS (Pinpoint) / Carrier dwell times"

  log_group_names = [
    aws_cloudwatch_log_group.pinpoint_deliveries.name,
    aws_cloudwatch_log_group.pinpoint_deliveries_failures.name,
  ]

  query_string = <<QUERY
stats avg((eventTimestamp - messageRequestTimestamp) / 1000 / 60) as Avg_carrier_time_minutes,
count(*) as Number by carrierName as Carrier
| filter isFinal
| sort by Avg_carrier_time_minutes desc
| limit 100
QUERY
}

resource "aws_cloudwatch_query_definition" "pinpoint-failures-by-carrier" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "SMS (Pinpoint) / Failures by carrier"

  log_group_names = [
    aws_cloudwatch_log_group.pinpoint_deliveries.name,
    aws_cloudwatch_log_group.pinpoint_deliveries_failures.name,
  ]

  query_string = <<QUERY
filter isFinal
| filter messageStatus not like /DELIVERED|SUCCESSFUL/
| stats count(*) as Total by carrierName, messageStatus
| sort by Total desc
QUERY
}

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
