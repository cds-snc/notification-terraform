###
# AWS Route 53 for Notification application
###

resource "aws_route53_resolver_query_log_config" "dns_query_log_config" {
  count           = var.cloudwatch_enabled ? 1 : 0
  name            = "${var.region}_${var.account_id}_dns_query_log_config"
  destination_arn = aws_cloudwatch_log_group.route53_resolver_query_log[0].arn

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_route53_resolver_query_log_config_association" "dns_query_log_config_association" {
  count                        = var.cloudwatch_enabled ? 1 : 0
  resolver_query_log_config_id = aws_route53_resolver_query_log_config.dns_query_log_config[0].id
  resource_id                  = aws_vpc.notification-canada-ca.id
}
