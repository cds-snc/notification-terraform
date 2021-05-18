###
# AWS CloudWatch Log Groups
###
resource "aws_cloudwatch_log_group" "sns_deliveries" {
  name = "sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_cloudwatch_log_group" "sns_deliveries_failures" {
  name = "sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber/Failure"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_cloudwatch_log_group" "ses_receiving_emails" {
  provider = aws.us-east-1

  name = "/aws/lambda/${var.lambda_ses_receiving_emails_name}"

  retention_in_days = 90

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_cloudwatch_log_group" "sns_deliveries_us_west_2" {
  provider = aws.us-west-2

  name = "sns/us-west-2/${var.account_id}/DirectPublishToPhoneNumber"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_cloudwatch_log_group" "sns_deliveries_failures_us_west_2" {
  provider = aws.us-west-2

  name = "sns/us-west-2/${var.account_id}/DirectPublishToPhoneNumber/Failure"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_cloudwatch_log_group" "route53_resolver_query_log" {
  provider = aws.us-east-1

  name = "route53/${var.region}/${var.account_id}/DNS/logs"

  retention_in_days = 14

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

###
# AWS CloudWatch Logs Metrics
###
resource "aws_cloudwatch_log_metric_filter" "sns-sms-blocked-as-spam" {
  name = "sns-sms-blocked-as-spam"
  # See https://docs.amazonaws.cn/en_us/sns/latest/dg/sms_stats_cloudwatch.html#sms_stats_delivery_fail_reasons
  pattern        = "{ $.delivery.providerResponse = \"Blocked as spam by phone carrier\" }"
  log_group_name = aws_cloudwatch_log_group.sns_deliveries_failures.name

  metric_transformation {
    name          = "sns-sms-blocked-as-spam"
    namespace     = "LogMetrics"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "sns-sms-blocked-as-spam-us-west-2" {
  provider = aws.us-west-2

  name = "sns-sms-blocked-as-spam-us-west-2"
  # See https://docs.amazonaws.cn/en_us/sns/latest/dg/sms_stats_cloudwatch.html#sms_stats_delivery_fail_reasons
  pattern        = "{ $.delivery.providerResponse = \"Blocked as spam by phone carrier\" }"
  log_group_name = aws_cloudwatch_log_group.sns_deliveries_failures_us_west_2.name

  metric_transformation {
    name          = "sns-sms-blocked-as-spam-us-west-2"
    namespace     = "LogMetrics"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "sns-sms-phone-carrier-unavailable" {
  name = "sns-sms-phone-carrier-unavailable"
  # See https://docs.amazonaws.cn/en_us/sns/latest/dg/sms_stats_cloudwatch.html#sms_stats_delivery_fail_reasons
  pattern        = "{ $.delivery.providerResponse = \"Phone carrier is currently unreachable/unavailable\" }"
  log_group_name = aws_cloudwatch_log_group.sns_deliveries_failures.name

  metric_transformation {
    name          = "sns-sms-phone-carrier-unavailable"
    namespace     = "LogMetrics"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "sns-sms-phone-carrier-unavailable-us-west-2" {
  provider = aws.us-west-2

  name = "sns-sms-phone-carrier-unavailable-us-west-2"
  # See https://docs.amazonaws.cn/en_us/sns/latest/dg/sms_stats_cloudwatch.html#sms_stats_delivery_fail_reasons
  pattern        = "{ $.delivery.providerResponse = \"Phone carrier is currently unreachable/unavailable\" }"
  log_group_name = aws_cloudwatch_log_group.sns_deliveries_failures_us_west_2.name

  metric_transformation {
    name          = "sns-sms-phone-carrier-unavailable-us-west-2"
    namespace     = "LogMetrics"
    value         = "1"
    default_value = "0"
  }
}

###
# AWS CloudWatch Logs Subscriptions
###
resource "aws_cloudwatch_log_subscription_filter" "sns_to_lambda" {
  name            = "sns_to_lambda"
  log_group_name  = aws_cloudwatch_log_group.sns_deliveries.name
  filter_pattern  = ""
  destination_arn = aws_lambda_function.sns_to_sqs_sms_callbacks.arn
}

resource "aws_cloudwatch_log_subscription_filter" "sns_failures_to_lambda" {
  name            = "sns_failures_to_lambda"
  log_group_name  = aws_cloudwatch_log_group.sns_deliveries_failures.name
  filter_pattern  = ""
  destination_arn = aws_lambda_function.sns_to_sqs_sms_callbacks.arn
}

resource "aws_cloudwatch_log_subscription_filter" "sns_sms_us_west_2_to_lambda" {
  provider = aws.us-west-2

  name            = "sns_sms_us_west_2_to_lambda"
  log_group_name  = aws_cloudwatch_log_group.sns_deliveries_us_west_2.name
  filter_pattern  = ""
  destination_arn = aws_lambda_function.sns_to_sqs_sms_callbacks.arn
}

resource "aws_cloudwatch_log_subscription_filter" "sns_sms_failures_us_west_2_to_lambda" {
  provider = aws.us-west-2

  name            = "sns_sms_failures_us_west_2_to_lambda"
  log_group_name  = aws_cloudwatch_log_group.sns_deliveries_failures_us_west_2.name
  filter_pattern  = ""
  destination_arn = aws_lambda_function.sns_to_sqs_sms_callbacks.arn
}
