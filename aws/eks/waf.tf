resource "aws_wafv2_web_acl" "notification-canada-ca" {
  name        = "notification-canada-ca-waf"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "aws-managed-rules-common"
    priority = 1

    override_action {
      count {}
    }

    statement {
      # See https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        excluded_rule {
          name = "SizeRestrictions_QUERYSTRING"
        }

        excluded_rule {
          name = "NoUserAgent_HEADER"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "wafv2-aws-managed-rules-common"
      sampled_requests_enabled   = false
    }
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "wafv2"
    sampled_requests_enabled   = false
  }
}
