resource "aws_wafv2_regex_pattern_set" "re_admin" {
  name        = "re_admin"
  description = "Regex matching valid admin endpoints"
  scope       = "REGIONAL"

  # WAF Regex blocks are combined with OR logic. 
  # Regex support is limited, please see: 
  # https://docs.aws.amazon.com/waf/latest/developerguide/waf-regex-pattern-set-managing.html


  regular_expression {
    regex_string = "/.well-known|/_email|/_letter|/_status|/_styleguide|/a11y|/accounts|/accounts-or-dashboard|/activity|/add-service|/agreement|/callbacks|/contact|/design-patterns-content-guidance|/documentation|/email"
  }

  regular_expression {
    regex_string = "/email-branding|/email-not-received|/error|/features|/find-services-by-name|/find-users-by-email|/forced-password-reset|/forgot-password|/format|/inbound-sms-admin|/invitation|/letter-branding"
  }

  regular_expression {
    regex_string = "/letters|/messages-status|/new-password|/organisation-invitation|/organisations|/personalise|/platform-admin|/preview|/pricing|/provider|/providers|/register|/register-from-invite"

  }

  regular_expression {
    regex_string = "/register-from-org-invite|/registration-continue|/resend-email-verification|/roadmap|/robots.txt|/send-new-code|/send-new-email-token|/services|/services-or-dashboard|/set-lang|/sign-in|/sign-out|/sms"

  }

  regular_expression {
    regex_string = "/static|/support|/templates|/text-not-received|/two-factor-email-sent|/two-factor-sms-sent|/user-profile|/users|/verify|/verify-email|/verify-mobile|/welcome|/why-notify"
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}
