resource "aws_wafv2_regex_pattern_set" "re_admin" {
  name        = "re_admin"
  description = "Regex matching valid admin endpoints"
  scope       = "REGIONAL"

  # WAF Regex blocks are combined with OR logic. 
  # Regex support is limited, please see: 
  # https://docs.aws.amazon.com/waf/latest/developerguide/waf-regex-pattern-set-managing.html


  regular_expression {
    regex_string = "/.well-known"
  }
  #   regular_expression {
  #     regex_string = "/<path:path>"
  #   }
  regular_expression {
    regex_string = "/_email"
  }
  #   regular_expression {
  #     regex_string = "/_letter"
  #   }
  regular_expression {
    regex_string = "/_status"
  }
  regular_expression {
    regex_string = "/_styleguide"
  }
  regular_expression {
    regex_string = "/a11y"
  }
  regular_expression {
    regex_string = "/accounts"
  }
  regular_expression {
    regex_string = "/accounts-or-dashboard"
  }
  regular_expression {
    regex_string = "/activity"
  }
  regular_expression {
    regex_string = "/add-service"
  }
  regular_expression {
    regex_string = "/agreement"
  }
  regular_expression {
    regex_string = "/callbacks"
  }
  regular_expression {
    regex_string = "/contact"
  }
  #   regular_expression {
  #     regex_string = "/design-patterns-content-guidance"
  #   }
  regular_expression {
    regex_string = "/documentation"
  }
  regular_expression {
    regex_string = "/email"
  }
  regular_expression {
    regex_string = "/email-branding"
  }
  regular_expression {
    regex_string = "/email-not-received"
  }
  regular_expression {
    regex_string = "/error"
  }
  regular_expression {
    regex_string = "/features"
  }
  regular_expression {
    regex_string = "/find-services-by-name"
  }
  regular_expression {
    regex_string = "/find-users-by-email"
  }
  regular_expression {
    regex_string = "/forced-password-reset"
  }
  regular_expression {
    regex_string = "/forgot-password"
  }
  regular_expression {
    regex_string = "/format"
  }
  regular_expression {
    regex_string = "/inbound-sms-admin"
  }
  regular_expression {
    regex_string = "/invitation"
  }
  #   regular_expression {
  #     regex_string = "/letter-branding"
  #   }
  #   regular_expression {
  #     regex_string = "/letters"
  #   }
  regular_expression {
    regex_string = "/messages-status"
  }
  regular_expression {
    regex_string = "/new-password"
  }
  regular_expression {
    regex_string = "/organisation-invitation"
  }
  regular_expression {
    regex_string = "/organisations"
  }
  regular_expression {
    regex_string = "/personalise"
  }
  regular_expression {
    regex_string = "/platform-admin"
  }
  regular_expression {
    regex_string = "/preview"
  }
  regular_expression {
    regex_string = "/pricing"
  }
  regular_expression {
    regex_string = "/provider"
  }
  regular_expression {
    regex_string = "/providers"
  }
  regular_expression {
    regex_string = "/register"
  }
  regular_expression {
    regex_string = "/register-from-invite"
  }
  regular_expression {
    regex_string = "/register-from-org-invite"
  }
  regular_expression {
    regex_string = "/registration-continue"
  }
  regular_expression {
    regex_string = "/resend-email-verification"
  }
  regular_expression {
    regex_string = "/** roadmap"
  }
  regular_expression {
    regex_string = "/robots.txt"
  }
  regular_expression {
    regex_string = "/send-new-code"
  }
  regular_expression {
    regex_string = "/send-new-email-token"
  }
  regular_expression {
    regex_string = "/services"
  }
  regular_expression {
    regex_string = "/services-or-dashboard"
  }
  regular_expression {
    regex_string = "/set-lang"
  }
  regular_expression {
    regex_string = "/sign-in"
  }
  regular_expression {
    regex_string = "/sign-out"
  }
  regular_expression {
    regex_string = "/sms"
  }
  regular_expression {
    regex_string = "/static"
  }
  regular_expression {
    regex_string = "/support"
  }
  regular_expression {
    regex_string = "/templates"
  }
  regular_expression {
    regex_string = "/text-not-received"
  }
  regular_expression {
    regex_string = "/two-factor-email-sent"
  }
  regular_expression {
    regex_string = "/two-factor-sms-sent"
  }
  regular_expression {
    regex_string = "/user-profile"
  }
  regular_expression {
    regex_string = "/users"
  }
  regular_expression {
    regex_string = "/verify"
  }
  regular_expression {
    regex_string = "/verify-email"
  }
  regular_expression {
    regex_string = "/verify-mobile"
  }
  regular_expression {
    regex_string = "/welcome"
  }
  regular_expression {
    regex_string = "/why-notify"
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}
