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

resource "aws_cloudwatch_query_definition" "sms-interntional-sending-status" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "SMS (SNS) / International sending status"

  log_group_names = [
    aws_cloudwatch_log_group.sns_deliveries.name,
    aws_cloudwatch_log_group.sns_deliveries_failures.name
  ]

  query_string = <<QUERY
fields @timestamp, @message
| parse @message /"isoCountryCode":"(?<Country>[^"]+)"/
| parse @message /"eventType":"(?<Event_Type>[^"]+)"/
| parse @message /"isFinal":(?<Is_Final>\w+)/
| filter Is_Final = "true"
| stats count(*) as Event_Count by Country, Event_Type
| display Country, Event_Type, Event_Count
| sort Country asc
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
