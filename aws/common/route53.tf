###
# AWS Route 53 for Notification application
###

resource "aws_route53_resolver_query_log_config" "dns_query_log_config" {
  provider        = aws.us-east-1
  count           = var.cloudwatch_enabled ? 1 : 0
  name            = "${var.region}_${var.account_id}_dns_query_log_config"
  destination_arn = aws_cloudwatch_log_group.route53_resolver_query_log[0].arn

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }

  depends_on = [
    aws_cloudwatch_log_resource_policy.route53_resolver_query_logging_policy
  ]
}

# Route53 Resolver Query Logging Configuration
resource "aws_route53_resolver_query_log_config" "main" {
  provider = aws.us-east-1
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "route53-query-logging"

  destination_arn = aws_cloudwatch_log_group.route53_resolver_query_log[0].arn

  tags = {
    Environment = var.env
    CostCenter  = "notification-canada-ca-${var.env}"
    Service     = "dns-monitoring"
  }

  depends_on = [
    aws_cloudwatch_log_resource_policy.route53_resolver_query_logging_policy
  ]
}

# Associate query logging with VPCs
resource "aws_route53_resolver_query_log_config_association" "main" {
  count = var.cloudwatch_enabled ? length(var.vpc_ids) : 0

  resolver_query_log_config_id = aws_route53_resolver_query_log_config.main[0].id
  resource_id                  = var.vpc_ids[count.index]
}

# Metric Filter for NXDOMAIN errors on notification.cdssandbox.ca domain - public DNS only
resource "aws_cloudwatch_log_metric_filter" "route53_nxdomain_notification" {
  provider = aws.us-east-1
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Route53NXDOMAINNotificationDomain"
  # Pattern simplified to only exclude internal queries
  pattern        = "?${var.base_domain} NXDOMAIN"
  log_group_name = aws_cloudwatch_log_group.route53_resolver_query_log[0].name

  metric_transformation {
    name      = "Route53PublicDNSResolutionFailureCount"
    namespace = "Route53/PublicResolver"
    value     = "1"
  }
}

# Metric Filter for SERVFAIL errors on notification.cdssandbox.ca domain - public DNS only
resource "aws_cloudwatch_log_metric_filter" "route53_servfail_notification" {
  provider = aws.us-east-1
  count    = var.cloudwatch_enabled ? 1 : 0
  name     = "Route53SERVFAILNotificationDomain"
  # Pattern simplified to only exclude internal queries
  pattern        = "?${var.base_domain} SERVFAIL"
  log_group_name = aws_cloudwatch_log_group.route53_resolver_query_log[0].name

  metric_transformation {
    name      = "Route53PublicDNSResolutionFailureCount"
    namespace = "Route53/PublicResolver"
    value     = "1"
  }
}
