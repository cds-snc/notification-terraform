#
# Pinpoint will log delivery receipts to these two log groups
#

resource "aws_cloudwatch_log_group" "pinpoint_deliveries" {
  name              = "sns/${var.region}/${var.account_id}/PinpointDirectPublishToPhoneNumber"
  retention_in_days = var.sensitive_log_retention_period_days
  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_cloudwatch_log_group" "pinpoint_deliveries_failures" {
  name              = "sns/${var.region}/${var.account_id}/PinpointDirectPublishToPhoneNumber/Failure"
  retention_in_days = var.sensitive_log_retention_period_days
  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

#
# pinpoint_to_sqs_sms_callbacks lambda function logs
#

resource "aws_cloudwatch_log_group" "pinpoint_to_sqs_sms_callbacks_log_group" {
  count             = var.cloudwatch_enabled ? 1 : 0
  name              = "pinpoint_to_sqs_sms_callbacks_log_group"
  retention_in_days = var.sensitive_log_retention_period_days
  tags = {
    CostCenter  = "notification-canada-ca-${var.env}"
    Environment = var.env
    Application = "lambda"
  }
}

resource "aws_cloudwatch_log_metric_filter" "pinpoint_to_sqs_sms_callbacks-500-errors-api" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "pinpoint_to_sqs_sms_callbacks-500-errors-api"
  pattern        = "\"\\\"levelname\\\": \\\"ERROR\\\"\""
  log_group_name = "/aws/lambda/${module.pinpoint_to_sqs_sms_callbacks.function_name}"

  metric_transformation {
    name      = "500-errors-pinpoint_to_sqs_sms_callbacks-api"
    namespace = "LogMetrics"
    value     = "1"
  }
}

###
# AWS CloudWatch Logs Metrics
###
resource "aws_cloudwatch_log_metric_filter" "pinpoint-sms-blocked-as-spam" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "pinpoint-sms-blocked-as-spam"
  # See https://docs.aws.amazon.com/sms-voice/latest/userguide/configuration-sets-event-format.html
  pattern        = "{ $.messageStatus = \"SPAM\" }"
  log_group_name = aws_cloudwatch_log_group.pinpoint_deliveries_failures.name

  metric_transformation {
    name          = "pinpoint-sms-blocked-as-spam"
    namespace     = "LogMetrics"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "pinpoint-sms-phone-carrier-unavailable" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "pinpoint-sms-phone-carrier-unavailable"
  # See https://docs.aws.amazon.com/sms-voice/latest/userguide/configuration-sets-event-format.html
  pattern        = "{ $.messageStatus = \"CARRIER_UNREACHABLE\" }"
  log_group_name = aws_cloudwatch_log_group.pinpoint_deliveries_failures.name

  metric_transformation {
    name          = "pinpoint-sms-phone-carrier-unavailable"
    namespace     = "LogMetrics"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "pinpoint-sms-rate-exceeded" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "pinpoint-sms-rate-exceeded"
  # https://docs.aws.amazon.com/sns/latest/dg/channels-sms-originating-identities-long-codes.html
  # Canadian long code numbers are limited at 1 SMS per second/number
  pattern        = "{ $.messageStatusDescription = \"Rate exceeded.\" }"
  log_group_name = aws_cloudwatch_log_group.pinpoint_deliveries_failures.name

  metric_transformation {
    name          = "pinpoint-sms-rate-exceeded"
    namespace     = "LogMetrics"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "pinpoint-sms-successes" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "pinpoint-sms-successes"
  pattern        = "{ ($.isFinal IS TRUE) && ( ($.messageStatus = \"SUCCESSFUL\") || ($.messageStatus = \"DELIVERED\") ) }"
  log_group_name = aws_cloudwatch_log_group.pinpoint_deliveries.name

  metric_transformation {
    name          = "pinpoint-sms-successes"
    namespace     = "LogMetrics"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "pinpoint-sms-failures" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "pinpoint-sms-failures"
  pattern        = "{ ($.isFinal IS TRUE) && ( ($.messageStatus != \"SUCCESSFUL\") && ($.messageStatus != \"DELIVERED\") ) }"
  log_group_name = aws_cloudwatch_log_group.pinpoint_deliveries_failures.name

  metric_transformation {
    name          = "pinpoint-sms-failures"
    namespace     = "LogMetrics"
    value         = "1"
    default_value = "0"
  }
}
