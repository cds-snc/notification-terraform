###
# AWS Route 53 for Notification application
###

resource "aws_route53_resolver_query_log_config" "dns_query_log_config" {
  name            = "us-west-2/${var.account_id}/dns_query_log_config"
  destination_arn = [aws_cloudwatch_log_group.route53_resolver_query_log.arn]

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}
