###
# AWS CloudWatch Log Groups
###
resource "aws_cloudwatch_log_group" "sns_deliveries" {
  count             = var.cloudwatch_enabled ? 1 : 0
  name              = "sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber"
  retention_in_days = var.sensitive_log_retention_period_days
  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_cloudwatch_log_group" "sns_deliveries_failures" {
  count             = var.cloudwatch_enabled ? 1 : 0
  name              = "sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber/Failure"
  retention_in_days = var.sensitive_log_retention_period_days

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_cloudwatch_log_group" "sns_deliveries_us_west_2" {
  provider = aws.us-west-2

  count             = var.cloudwatch_enabled ? 1 : 0
  name              = "sns/us-west-2/${var.account_id}/DirectPublishToPhoneNumber"
  retention_in_days = var.sensitive_log_retention_period_days

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_cloudwatch_log_group" "sns_deliveries_failures_us_west_2" {
  provider = aws.us-west-2

  count             = var.cloudwatch_enabled ? 1 : 0
  name              = "sns/us-west-2/${var.account_id}/DirectPublishToPhoneNumber/Failure"
  retention_in_days = var.sensitive_log_retention_period_days

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_cloudwatch_log_group" "route53_resolver_query_log" {
  provider          = aws.us-east-1 # Ensure this log group is created in us-east-1
  count             = var.cloudwatch_enabled ? 1 : 0
  name              = "route53/us-east-1/${var.account_id}/DNS/logs"
  retention_in_days = var.log_retention_period_days

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

# Resource policy to allow Route 53 to write to CloudWatch Logs
resource "aws_cloudwatch_log_resource_policy" "route53_resolver_query_logging_policy" {
  provider       = aws.us-east-1 # Ensure policy is created in us-east-1 for the log group
  count           = var.cloudwatch_enabled ? 1 : 0
  policy_name     = "route53-resolver-query-logging-policy"
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Route53LogsToCloudWatchLogs"
        Effect = "Allow"
        Principal = {
          Service = [
            "route53.amazonaws.com"
          ]
        }
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = aws_cloudwatch_log_group.route53_resolver_query_log[0].arn
      }
    ]
  })
}

###
# AWS CloudWatch Logs Metrics
###
resource "aws_cloudwatch_log_metric_filter" "sns-sms-blocked-as-spam" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "sns-sms-blocked-as-spam"
  # See https://docs.amazonaws.cn/en_us/sns/latest/dg/sms_stats_cloudwatch.html#sms_stats_delivery_fail_reasons
  pattern        = "{ $.delivery.providerResponse = \"Blocked as spam by phone carrier\" }"
  log_group_name = aws_cloudwatch_log_group.sns_deliveries_failures[0].name

  metric_transformation {
    name          = "sns-sms-blocked-as-spam"
    namespace     = "LogMetrics"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "sns-sms-blocked-as-spam-us-west-2" {
  provider = aws.us-west-2

  count = var.cloudwatch_enabled ? 1 : 0
  name  = "sns-sms-blocked-as-spam-us-west-2"
  # See https://docs.amazonaws.cn/en_us/sns/latest/dg/sms_stats_cloudwatch.html#sms_stats_delivery_fail_reasons
  pattern        = "{ $.delivery.providerResponse = \"Blocked as spam by phone carrier\" }"
  log_group_name = aws_cloudwatch_log_group.sns_deliveries_failures_us_west_2[0].name

  metric_transformation {
    name          = "sns-sms-blocked-as-spam-us-west-2"
    namespace     = "LogMetrics"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "sns-sms-phone-carrier-unavailable" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "sns-sms-phone-carrier-unavailable"
  # See https://docs.amazonaws.cn/en_us/sns/latest/dg/sms_stats_cloudwatch.html#sms_stats_delivery_fail_reasons
  pattern        = "{ $.delivery.providerResponse = \"Phone carrier is currently unreachable/unavailable\" }"
  log_group_name = aws_cloudwatch_log_group.sns_deliveries_failures[0].name

  metric_transformation {
    name          = "sns-sms-phone-carrier-unavailable"
    namespace     = "LogMetrics"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "sns-sms-phone-carrier-unavailable-us-west-2" {
  provider = aws.us-west-2

  count = var.cloudwatch_enabled ? 1 : 0
  name  = "sns-sms-phone-carrier-unavailable-us-west-2"
  # See https://docs.amazonaws.cn/en_us/sns/latest/dg/sms_stats_cloudwatch.html#sms_stats_delivery_fail_reasons
  pattern        = "{ $.delivery.providerResponse = \"Phone carrier is currently unreachable/unavailable\" }"
  log_group_name = aws_cloudwatch_log_group.sns_deliveries_failures_us_west_2[0].name

  metric_transformation {
    name          = "sns-sms-phone-carrier-unavailable-us-west-2"
    namespace     = "LogMetrics"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "sns-sms-rate-exceeded" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "sns-sms-rate-exceeded"
  # See https://docs.amazonaws.cn/en_us/sns/latest/dg/sms_stats_cloudwatch.html#sms_stats_delivery_fail_reasons
  # https://docs.aws.amazon.com/sns/latest/dg/channels-sms-originating-identities-long-codes.html
  # Canadian long code numbers are limited at 1 SMS per second/number
  pattern        = "{ $.delivery.providerResponse = \"Rate exceeded.\" }"
  log_group_name = aws_cloudwatch_log_group.sns_deliveries_failures[0].name

  metric_transformation {
    name          = "sns-sms-rate-exceeded"
    namespace     = "LogMetrics"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "sns-sms-rate-exceeded-us-west-2" {
  provider = aws.us-west-2

  count = var.cloudwatch_enabled ? 1 : 0
  name  = "sns-sms-rate-exceeded-us-west-2"
  # See https://docs.amazonaws.cn/en_us/sns/latest/dg/sms_stats_cloudwatch.html#sms_stats_delivery_fail_reasons
  # https://docs.aws.amazon.com/sns/latest/dg/channels-sms-originating-identities-long-codes.html
  # Canadian long code numbers are limited at 1 SMS per second/number
  pattern        = "{ $.delivery.providerResponse = \"Rate exceeded.\" }"
  log_group_name = aws_cloudwatch_log_group.sns_deliveries_failures_us_west_2[0].name

  metric_transformation {
    name          = "sns-sms-rate-exceeded-us-west-2"
    namespace     = "LogMetrics"
    value         = "1"
    default_value = "0"
  }
}


