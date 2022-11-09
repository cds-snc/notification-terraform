resource "aws_wafv2_regex_pattern_set" "re_admin" {
  name        = "re_admin"
  description = "Regex matching valid admin endpoints"
  scope       = "REGIONAL"

  # WAF Regex blocks are combined with OR logic. 
  # Regex support is limited, please see: 
  # https://docs.aws.amazon.com/waf/latest/developerguide/waf-regex-pattern-set-managing.html

  regular_expression {
    regex_string = "/.well-known.*|/_email.*|/_letter.*|/_status.*|/_styleguide.*|/a11y.*|/accounts.*|/accounts-or-dashboard.*|/activity.*|/add-service.*|/agreement.*|/callbacks.*|/contact.*|/documentation.*|/email.*"
  }

  regular_expression {
    regex_string = "/email-branding.*|/email-not-received.*|/error.*|/features.*|/find-services-by-name.*|/find-users-by-email.*|/forced-password-reset.*|/forgot-password.*|/format.*|/inbound-sms-admin.*|/invitation.*"
  }

  regular_expression {
    regex_string = "/letters.*|/messages-status.*|/new-password.*|/organisation-invitation.*|/organisations.*|/personalise.*|/platform-admin.*|/preview.*|/pricing.*|/provider.*|/providers.*|/register.*"
  }

  regular_expression {
    regex_string = "/register-from-org-invite.*|/registration-continue.*|/resend-email-verification.*|/roadmap.*|/robots.txt.*|/send-new-code.*|/send-new-email-token.*|/services.*|/services-or-dashboard.*|/set-lang.*"
  }

  regular_expression {
    regex_string = "/static.*|/support.*|/templates.*|/text-not-received.*|/two-factor-email-sent.*|/two-factor-sms-sent.*|/user-profile.*|/users.*|/verify.*|/verify-email.*|/verify-mobile.*|/welcome.*|/why-notify.*"
  }

  regular_expression {
    regex_string = "/design-patterns-content-guidance.*|/letter-branding.*|/register-from-invite.*|/sign-in.*|/sign-out.*|/sms.*"
  }

  # GCA routes
  regular_expression {
    regex_string = "/home|/accueil|/why-gc-notify|/pourquoi-gc-notification|/features|/fonctionnalites|/guidance|/guides-reference|/securit.+|/privacy.*|/confidentialite.*|/accessibility|/accessibilite"
  }

  # GCA routes
  regular_expression {
    regex_string = "/terms|/conditions-dutilisation|/personalisation-guide|/guide-personnalisation|/message-delivery-status|/etat-livraison-messages|/formatting-guide|/guide-mise-en-forme|/spreadsheets|/feuille-de-calcu"
  }


  # GCA routes
  regular_expression {
    regex_string = "/other-services|/autres-services|/service-level-agreement|/accord-niveaux-de-service|/service-level-objectives|/objectifs-niveau-de-service"
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}
