resource "aws_wafv2_ip_set" "ip_blocklist" {
  name               = "ip_blocklist"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses = [
    "40.50.60.70/32",
    "103.14.26.118/32"
  ]

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_wafv2_regex_pattern_set" "re_api" {
  name        = "re_api"
  description = "Regex matching valid api endpoints"
  scope       = "REGIONAL"

  regular_expression {
    regex_string = var.env == "production" ? "/_status.*|/api-key.*|/complaint.*|/email-branding.*|/events.*|/inbound-number.*|/invite.*|/letter-branding.*|/letters.*|/template-category.*" : "/_debug|/_status.*|/api-key.*|/complaint.*|/email-branding.*|/events.*|/inbound-number.*|/invite.*|/letter-branding.*|/letters.*|/template-category.*|/cypress.*"
  }

  regular_expression {
    regex_string = "/notifications.*|/organisation.*|/organisations.*|/platform-stats.*|/provider-details.*|/service.*|/static.*|/user.*|/v2.*|/cache-clear"
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_wafv2_regex_pattern_set" "re_admin" {
  name        = "re_admin"
  description = "Regex matching valid admin endpoints"
  scope       = "REGIONAL"

  # WAF Regex blocks are combined with OR logic.
  # Regex support is limited, please see:
  # https://docs.aws.amazon.com/waf/latest/developerguide/waf-regex-pattern-set-managing.html

  regular_expression {
    regex_string = "/.well-known.*|/_email.*|/_letter.*|/_status.*|/_styleguide.*|/a11y.*|/accounts.*|/accounts-or-dashboard.*|/activity.*|/add-service.*|/callbacks.*|/contact.*|/documentation.*|/email.*"
  }

  regular_expression {
    regex_string = "/email-branding.*|/email-not-received.*|/error.*|/features.*|/find-services-by-name.*|/find-users-by-email.*|/forced-password-reset.*|/forgot-password.*|/format.*|/inbound-sms-admin.*|/invitation.*"
  }

  regular_expression {
    regex_string = var.env == "production" ? "/letters.*|/messages-status.*|/new-password.*|/organisation-invitation.*|/organisations.*|/personalise.*|/platform-admin.*|/preview.*|/pricing.*|/provider.*|/providers.*|/register.*" : "/_debug|/letters.*|/messages-status.*|/new-password.*|/organisation-invitation.*|/organisations.*|/personalise.*|/platform-admin.*|/preview.*|/pricing.*|/provider.*|/providers.*|/register.*"
  }

  regular_expression {
    regex_string = "/register-from-org-invite.*|/registration-continue.*|/resend-email-verification.*|/roadmap.*|/robots.txt.*|/send-new-code.*|/send-new-email-token.*|/services.*|/services-or-dashboard.*|/set-lang.*"
  }

  regular_expression {
    regex_string = "/static.*|/support.*|/templates.*|/text-not-received.*|/two-factor-email-sent.*|/two-factor-sms-sent.*|/user-profile.*|/users.*|/verify.*|/verify-email.*|/verify-mobile.*|/welcome.*|/why-notify.*"
  }

  regular_expression {
    regex_string = "/design-patterns-content-guidance.*|/letter-branding.*|/register-from-invite.*|/sign-in.*|/sign-out.*|/sms.*|/archive-autres-services.*|/archived-version-other-services.*|/using-a-spreadsheet|/new-f.*"
  }

  # GCA routes
  regular_expression {
    regex_string = "/home|/accueil|/why-gc-notify|/pourquoi-gc-notification|/features|/fonctionnalites|/guidance|/guides-reference|/securit.+|/privacy.*|/confidentialite.*|/accessibility|/accessibilite|/nouvelles-fonc.*"
  }

  # GCA routes
  regular_expression {
    regex_string = "/terms|/conditions-dutilisation|/personalisation-guide|/guide-personnalisation|/.*-delivery-.*|/etat-livraison-messages|/formatting-.*|/guide-mise-en-forme|/spreadsheets|/feuille-de-calcu|/sins.*demo"
  }

  # GCA routes
  regular_expression {
    regex_string = "/other-services|/autres-services|/service-level-agreement|/accord-niveaux-de-service|/service-level-objectives|/objectifs-niveau-de-service|/pourquoi-notification-gc|/envoyer-.*-personnalise|/reg.*emo"
  }

  # GCA routes
  regular_expression {
    regex_string = "/.*-contact-information|/.*-a-jour-les-coordonnees|/delivery-and-failure|/livraison-.*-et-echec|/system-status|/etat-du-systeme|/comprendre-.*-livraison|/sending-custom-content|/utiliser-.*-de-calcul"
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_wafv2_regex_pattern_set" "re_admin2" {
  name        = "re_admin2"
  description = "Regex matching valid admin endpoints"
  scope       = "REGIONAL"

  # WAF Regex blocks are combined with OR logic.
  # Regex support is limited, please see:
  # https://docs.aws.amazon.com/waf/latest/developerguide/waf-regex-pattern-set-managing.html

  regular_expression {
    regex_string = "/sitemap|/plandesite|/agree-terms|/getting-started|/decouvrir-notification-gc|/template-category.*|/template-categories.*|/mettre-en-forme-les-courriels"
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_wafv2_regex_pattern_set" "re_document_download" {
  name        = "re_document_download"
  description = "Regex matching valid document download endpoints"
  scope       = "REGIONAL"

  # WAF Regex blocks are combined with OR logic.
  # Regex support is limited, please see:
  # https://docs.aws.amazon.com/waf/latest/developerguide/waf-regex-pattern-set-managing.html

  # GET /_status and /_debug
  regular_expression {
    regex_string = var.env == "production" ? "/_status" : "/_status|/_debug"
  }

  # GET /services/<uuid:service_id>/documents/<uuid:document_id>
  regular_expression {
    regex_string = "/services/[\\w]{8}-[\\w]{4}-[\\w]{4}-[\\w]{4}-[\\w]{12}/documents/[\\w]{8}-[\\w]{4}-[\\w]{4}-[\\w]{4}-[\\w]{12}"
  }

  # GET /d/<base64_uuid:service_id>/<base64_uuid:document_id>
  regular_expression {
    regex_string = "/d/[\\S]{22}/[\\S]{22}"
  }

  # POST /services/<uuid:service_id>/documents
  regular_expression {
    regex_string = "/services/[\\w]{8}-[\\w]{4}-[\\w]{4}-[\\w]{4}-[\\w]{12}/documents"
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_wafv2_regex_pattern_set" "re_documentation" {
  name        = "re_documentation"
  description = "Regex matching valid documentation website endpoints"
  scope       = "REGIONAL"

  # WAF Regex blocks are combined with OR logic.
  # Regex support is limited, please see:
  # https://docs.aws.amazon.com/waf/latest/developerguide/waf-regex-pattern-set-managing.html

  regular_expression {
    regex_string = "/assets/img/|/assets/js/|/assets/css/"
  }

  regular_expression {
    regex_string = "/en|/en/|/en/start.*|/en/send|/en/status.*|/en/testing.*|/en/keys.*|/en/limits.*|/en/callbacks.*|/en/architecture.*|/en/clients.*"
  }

  regular_expression {
    regex_string = "/fr|/fr/|/fr/commencer.*|/fr/envoyer.*|/fr/etat.*|/fr/cles.*|/fr/limites.*|/fr/rappel.*|/fr/architecture.*|/fr/clients.*"
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_wafv2_regex_pattern_set" "notification_base_url" {
  name        = "notification_base_url"
  description = "Regex matching the root domain of notify"
  scope       = "REGIONAL"

  # WAF Regex blocks are combined with OR logic.
  # Regex support is limited, please see:
  # https://docs.aws.amazon.com/waf/latest/developerguide/waf-regex-pattern-set-managing.html

  regular_expression {
    regex_string = "${var.domain}$"
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}
