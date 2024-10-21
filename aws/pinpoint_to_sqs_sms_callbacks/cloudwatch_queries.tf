resource "aws_cloudwatch_query_definition" "pinpoint-sms-blocked-as-spam" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "SMS (Pinpoint) / Block as spam"

  log_group_names = [
    aws_cloudwatch_log_group.pinpoint_deliveries_failures.name
  ]

  query_string = <<QUERY
fields @timestamp as Timestamp, carrierName as Carrier, messageStatus as `Provider response`, 
originationPhoneNumber as `Origination phone number`, destinationPhoneNumber as `Destination phone number`, 
messageId as `Message ID`, messageStatus as `Message Status`, 
messageStatusDescription as `Message status description`, @message
| filter isFinal
| filter eventType = 'TEXT_SPAM'
| sort Timestamp desc
| limit 100
}
QUERY
}

resource "aws_cloudwatch_query_definition" "pinpoint-sms-carrier-dwell-times" {
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

resource "aws_cloudwatch_query_definition" "pinpoint-sms-failures-by-carrier" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "SMS (Pinpoint) / Failures by carrier"

  log_group_names = [
    aws_cloudwatch_log_group.pinpoint_deliveries.name,
    aws_cloudwatch_log_group.pinpoint_deliveries_failures.name,
  ]

  query_string = <<QUERY
filter isFinal
| filter messageStatus not like /DELIVERED|SUCCESSFUL/
| stats count(*) as Total by coalesce(carrierName, 'Unknown/VOIP') as Carrier, messageStatus as MessageStatus
| sort by Total desc
QUERY
}

resource "aws_cloudwatch_query_definition" "pinpoint-sms-get-failures" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "SMS (Pinpoint) / Get failures"

  log_group_names = [
    aws_cloudwatch_log_group.pinpoint_deliveries_failures.name
  ]

  query_string = <<QUERY
fields @timestamp as Timestamp, carrierName as Carrier, messageStatus as `Provider response`, 
originationPhoneNumber as `Origination phone number`, destinationPhoneNumber as `Destination phone number`, 
messageId as `Message ID`, messageStatus as `Message Status`, 
messageStatusDescription as `Message status description`, @message
| filter isFinal
| sort @timestamp desc
| limit 100
QUERY
}

resource "aws_cloudwatch_query_definition" "pinpoint-sms-international-sending-status" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "SMS (Pinpoint) / International sending status"

  log_group_names = [
    aws_cloudwatch_log_group.pinpoint_deliveries.name,
    aws_cloudwatch_log_group.pinpoint_deliveries_failures.name
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
| limit 100
QUERY
}

resource "aws_cloudwatch_query_definition" "pinpoint-sms-get-sms-logs-by-dest-phone-number" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "SMS (Pinpoint) / Get SMS logs by destination phone number"

  log_group_names = [
    aws_cloudwatch_log_group.pinpoint_deliveries.name,
    aws_cloudwatch_log_group.pinpoint_deliveries_failures.name
  ]

  query_string = <<QUERY
fields @timestamp as Timestamp, carrierName as Carrier, messageStatus as `Provider response`, 
originationPhoneNumber as `Origination phone number`, destinationPhoneNumber as `Destination phone number`, 
messageId as `Message ID`, messageStatus as `Message Status`, 
messageStatusDescription as `Message status description`, @message
| filter destinationPhoneNumber like '+1416xxxxxxx'
| sort Timestamp desc
| limit 100
QUERY
}

resource "aws_cloudwatch_query_definition" "pinpoint-sms-get-sms-logs-by-orig-phone-number" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "SMS (Pinpoint) / Get SMS logs by origination phone number"

  log_group_names = [
    aws_cloudwatch_log_group.pinpoint_deliveries.name,
    aws_cloudwatch_log_group.pinpoint_deliveries_failures.name
  ]

  query_string = <<QUERY
fields @timestamp as Timestamp, carrierName as Carrier, messageStatus as `Provider response`, 
originationPhoneNumber as `Origination phone number`, destinationPhoneNumber as `Destination phone number`, 
messageId as `Message ID`, messageStatus as `Message Status`, 
messageStatusDescription as `Message status description`, @message
| filter originationPhoneNumber like '237762'
| sort Timestamp desc
| limit 100
QUERY
}

resource "aws_cloudwatch_query_definition" "pinpoint-sms-get-logs" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "SMS (Pinpoint) / Logs"

  log_group_names = [
    aws_cloudwatch_log_group.pinpoint_deliveries.name,
    aws_cloudwatch_log_group.pinpoint_deliveries_failures.name
  ]

  query_string = <<QUERY
fields @timestamp as Timestamp, carrierName as Carrier, messageStatus as `Provider response`, 
originationPhoneNumber as `Origination phone number`, destinationPhoneNumber as `Destination phone number`, 
messageId as `Message ID`, messageStatus as `Message Status`, 
messageStatusDescription as `Message status description`, @message
| filter isFinal
| sort @timestamp desc
| limit 100
QUERY
}

resource "aws_cloudwatch_query_definition" "pinpoint-sms-success-vs-unreachable" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "SMS (Pinpoint) / Success vs Unreachable"

  log_group_names = [
    aws_cloudwatch_log_group.pinpoint_deliveries.name,
    aws_cloudwatch_log_group.pinpoint_deliveries_failures.name
  ]

  query_string = <<QUERY
fields @timestamp as Timestamp, carrierName as Carrier, messageStatus as `Provider response`, 
originationPhoneNumber as `Origination phone number`, destinationPhoneNumber as `Destination phone number`, 
messageId as `Message ID`, messageStatus as `Message Status`, 
messageStatusDescription as `Message status description`, @message
| parse messageStatusDescription "Phone is currently unreachable/*" as @unavailable
| parse messageStatusDescription "Message has been * by phone" as @available
| stats count(@unavailable) as Unavailable, count(@available) as Available, count(*) as Total by bin(1h)
QUERY
}
