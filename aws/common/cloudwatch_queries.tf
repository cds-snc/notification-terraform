resource "aws_cloudwatch_query_definition" "sms-blocked-as-spam" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "SMS (SNS) / Block as spam"

  log_group_names = [
    aws_cloudwatch_log_group.sns_deliveries_failures.name
  ]

  query_string = <<QUERY
fields @timestamp as Timestamp, delivery.phoneCarrier as Carrier, delivery.providerResponse as `Provider response`, delivery.destination as `Destination phone number`
| filter delivery.providerResponse like 'spam'
| sort Timestamp desc
| limit 100
}
QUERY
}

resource "aws_cloudwatch_query_definition" "sms-carrier-dwell-times" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "SMS (SNS) / Carrier dwell times"

  log_group_names = [
    aws_cloudwatch_log_group.sns_deliveries.name,
    aws_cloudwatch_log_group.sns_deliveries_failures.name
  ]

  query_string = <<QUERY
stats avg(delivery.dwellTimeMsUntilDeviceAck / 1000 / 60) as Avg_carrier_time_minutes, 
| count(*) as Number by delivery.phoneCarrier as Carrier
QUERY
}

resource "aws_cloudwatch_query_definition" "sms-get-failures" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "SMS (SNS) / Get failures"

  log_group_names = [
    aws_cloudwatch_log_group.sns_deliveries_failures.name
  ]

  query_string = <<QUERY
fields @timestamp as Timestamp, status, delivery.phoneCarrier as Carrier, delivery.providerResponse as `Provider response`, delivery.destination as `Destination phone number`, notification.messageId as messageId, @message
| filter status = 'FAILURE'
| sort Timestamp desc
| limit 200
QUERY
}

resource "aws_cloudwatch_query_definition" "sms-get-sms-logs-by-phone-number" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "SMS (SNS) / Get SMS logs by phone number"

  log_group_names = [
    aws_cloudwatch_log_group.sns_deliveries.name,
    aws_cloudwatch_log_group.sns_deliveries_failures.name
  ]

  query_string = <<QUERY
fields @timestamp as Timestamp, status as Status, notification.messageId as `Message ID`,
    delivery.destination as `Destination phone number`, delivery.providerResponse as `Provider response`,
    delivery.smsType as `Message type`
| filter delivery.destination like '1416xxxxxxx'
| sort Timestamp desc
| limit 100
QUERY
}

resource "aws_cloudwatch_query_definition" "sms-international-sending-status" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "SMS (SNS) / International sending status"

  log_group_names = [
    aws_cloudwatch_log_group.sns_deliveries.name,
    aws_cloudwatch_log_group.sns_deliveries_failures.name
  ]

  query_string = <<QUERY
fields @timestamp, @message, delivery.mcc as CountryCode, status
| stats count(*) as Event_Count by CountryCode, status
| display CountryCode, status, Event_Count
| sort CountryCode asc
| limit 200
QUERY
}

resource "aws_cloudwatch_query_definition" "sms-success-vs-unreachable" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "SMS (SNS) / Success vs Unreachable"

  log_group_names = [
    aws_cloudwatch_log_group.sns_deliveries.name,
    aws_cloudwatch_log_group.sns_deliveries_failures.name
  ]

  query_string = <<QUERY
fields @timestamp, delivery.providerResponse
| parse delivery.providerResponse "Phone is currently unreachable/*" as @unavailable
| parse delivery.providerResponse "Message has been * by phone" as @available
| sort @timestamp desc
| stats count(@unavailable), count(@available), count(*) by bin(1h)
QUERY
}

resource "aws_cloudwatch_query_definition" "sms-unreachable-phone-numbers" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "SMS (SNS) / Success vs Unreachable"

  log_group_names = [
    aws_cloudwatch_log_group.sns_deliveries_failures.name
  ]

  query_string = <<QUERY
fields @timestamp, delivery.providerResponse
| filter delivery.providerResponse like "Phone is currently unreachable/unavailable"
| sort @timestamp desc
| limit 20
QUERY
}
