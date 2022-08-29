resource "aws_wafv2_regex_pattern_set" "re_api" {
  name        = "re_api"
  description = "Regex matching valid api endpoints"
  scope       = "REGIONAL"

  regular_expression {
    regex_string = "/_status.*|/api-key.*|/complaint.*|/email-branding.*|/events.*|/inbound-number.*|/invite.*|/letter-branding.*|/letters.*"
  }

  regular_expression {
    regex_string = "/notifications.*|/organisation.*|/organisations.*|/platform-stats.*|/provider-details.*|/service.*|/static.*|/user.*|/v2.*"
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

