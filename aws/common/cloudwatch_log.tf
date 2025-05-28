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
  count             = var.cloudwatch_enabled ? 1 : 0
  name              = "route53/${var.region}/${var.account_id}/DNS/logs"
  retention_in_days = var.log_retention_period_days

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
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

# Route53 Resolver Query Logging Configuration
resource "aws_route53_resolver_query_log_config" "main" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "${var.env}-route53-query-logging"

  destination_arn = aws_cloudwatch_log_group.route53_resolver_query_log[0].arn

  tags = {
    Environment = var.env
    CostCenter  = "notification-canada-ca-${var.env}"
    Service     = "dns-monitoring"
  }
}

# Associate query logging with VPCs
resource "aws_route53_resolver_query_log_config_association" "main" {
  count = var.cloudwatch_enabled ? length(var.vpc_ids) : 0

  resolver_query_log_config_id = aws_route53_resolver_query_log_config.main[0].id
  resource_id                  = var.vpc_ids[count.index]
}

# Metric Filter for NXDOMAIN errors on notification.cdssandbox.ca domain
resource "aws_cloudwatch_log_metric_filter" "route53_nxdomain_notification" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "Route53NXDOMAINNotificationDomain"
  # Simplified pattern that should be compatible with CloudWatch
  pattern        = "{ $.rcode = \"NXDOMAIN\" && $.query_name = \"*.notification.cdssandbox.ca\" }"
  log_group_name = aws_cloudwatch_log_group.route53_resolver_query_log[0].name

  metric_transformation {
    name      = "Route53DNSResolutionFailureCount"
    namespace = "Route53/Resolver"
    value     = "1"
  }
}

# Metric Filter for SERVFAIL errors on notification.cdssandbox.ca domain
resource "aws_cloudwatch_log_metric_filter" "route53_servfail_notification" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "Route53SERVFAILNotificationDomain"
  # Simplified pattern that should be compatible with CloudWatch
  pattern        = "{ $.rcode = \"SERVFAIL\" && $.query_name = \"*.notification.cdssandbox.ca\" }"
  log_group_name = aws_cloudwatch_log_group.route53_resolver_query_log[0].name

  metric_transformation {
    name      = "Route53DNSResolutionFailureCount"
    namespace = "Route53/Resolver"
    value     = "1"
  }
}

# SNS Topic for DNS resolution alarms
resource "aws_sns_topic" "dns_alarms" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "${var.env}-dns-resolution-alarms"

  tags = {
    Environment = var.env
    CostCenter  = "notification-canada-ca-${var.env}"
    Service     = "dns-monitoring"
  }
}

# CloudWatch Alarm for Route53 DNS resolution failures
resource "aws_cloudwatch_metric_alarm" "route53_dns_failures" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "${var.env}-route53-dns-resolution-failures"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "Route53DNSResolutionFailureCount"
  namespace           = "Route53/Resolver"
  period              = 300 # 5 minutes
  statistic           = "Sum"
  threshold           = var.dns_failure_threshold
  alarm_description   = "Alarm for Route53 DNS resolution failures exceeding threshold"
  alarm_actions       = [aws_sns_topic.dns_alarms[0].arn]
  ok_actions          = [aws_sns_topic.dns_alarms[0].arn]
  treat_missing_data  = "notBreaching"
}