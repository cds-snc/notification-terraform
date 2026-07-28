# =============================================================================
# WAF Rule Priority Index
# =============================================================================
# Rules run in ascending priority order. Low-WCU terminating rules run first
# so matched requests never reach expensive managed rule groups.
# WCU figures are approximate. Count-mode rules are noted with (count).
#
# Pri | WCU   | Name                                        | Action
# ----|-------|---------------------------------------------|----------------------------
#   1 |    ~1 | ip_blocklist                                | BLOCK
#   2 |   ~10 | BlockLargeRequests_CookiesAndHeaders        | count → BLOCK
#   3 |   ~15 | BlockLargeRequests_Body                     | count → BLOCK
#   4 |   ~20 | BlockFFUFUserAgent                          | BLOCK
#   5 |   ~20 | SigninRateLimitRule                         | BLOCK (rate, IP)
#   6 |   ~22 | SigninRateLimitRule_JA4                     | count → BLOCK (rate, JA4)
#   7 |   ~22 | ApiRateLimit_JA4                            | count → BLOCK (rate, JA4)
#   8 |   ~23 | CanadaUSOnlyGeoRestriction                  | BLOCK (API host, non-CA)
#   9 |   ~24 | MutatingApiRateLimit                        | count → BLOCK (rate, IP)
#  10 |   ~24 | MutatingApiRateLimit_JA4                    | count → BLOCK (rate, JA4)
#  11 |   ~25 | PreventHostInjections                       | BLOCK
#  12 |    25 | AWSManagedRulesAmazonIpReputationList        | BLOCK (managed)
#  13 |   ~26 | rate_limit_all_except_api                   | BLOCK (rate, IP)
#  14 |   ~26 | ApiRateLimit                                | BLOCK (rate, IP)
#  15 |   ~30 | AdminAuthenticatedPagesGeoRestriction        | count → BLOCK (non-CA)
#  16 |    50 | AWSManagedRulesAnonymousIpList               | BLOCK (managed)
#  17 |   157 | valid_paths                                 | BLOCK
#  18 |   200 | AWSManagedRulesKnownBadInputsRuleSet         | BLOCK (managed)
#  19 |   200 | AWSManagedRulesLinuxRuleSet                  | BLOCK (managed)
#  20 |   700 | AWSManagedRulesCommonRuleSet                 | BLOCK (managed, sets labels)
#  21 |    ~3 | BlockLabeled_SSRF_NoUserAgent_NonCA          | count → BLOCK (label, after 20)
#  22 |    ~6 | BlockSizeRestrictions_Body_ExcludeUploadPaths| count → BLOCK (label, after 20)
#  23 |    ~6 | BlockLFI_Body_ExcludeTemplatePaths           | count → BLOCK (label, after 20)
#  24 |    ~8 | BlockXSS_Body_ExcludeContentPaths            | count → BLOCK (label, after 20)
#  25 |   200 | AWSManagedRulesSQLiRuleSet                   | BLOCK (managed, sets labels)
#  26 |    ~6 | BlockSQLi_Body_ExcludeContentPaths           | count → BLOCK (label, after 25)
#  27 |    ?? | AWSManagedRulesAntiDDoSRuleSet               | count (managed, non-API only)
# =============================================================================

resource "aws_wafv2_web_acl" "notification-canada-ca" {
  provider = aws.core_services
  name     = "notification-canada-ca-waf"
  scope    = "REGIONAL"

  default_action {
    allow {}
  }

  # Rules are ordered to minimise compute spend: low-WCU rules with high
  # block potential run first so matched requests never reach the expensive
  # managed rule groups. WCU annotations are approximate; ordering also
  # accounts for block potential, not WCU alone.
  # See https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html

  # 1 WCU
  rule {
    name     = "ip_blocklist"
    priority = 1

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = var.ip_blocklist_arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockedIP"
      sampled_requests_enabled   = true
    }
  }

  # 20 WCU
  rule {
    name     = "BlockFFUFUserAgent"
    priority = 4

    action {
      block {}
    }

    statement {
      byte_match_statement {
        field_to_match {
          single_header {
            name = "user-agent"
          }
        }
        positional_constraint = "CONTAINS"
        search_string         = "fuzz faster"
        text_transformation {
          priority = 0
          type     = "LOWERCASE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockFFUFUserAgent"
      sampled_requests_enabled   = true
    }
  }

  # 23 WCU
  rule {
    name     = "CanadaUSOnlyGeoRestriction"
    priority = 8

    action {
      block {}
    }
    statement {
      and_statement {
        statement {
          byte_match_statement {
            positional_constraint = "STARTS_WITH"
            field_to_match {
              single_header {
                name = "host"
              }
            }
            search_string = "api"
            text_transformation {
              priority = 1
              type     = "COMPRESS_WHITE_SPACE"
            }
            text_transformation {
              priority = 2
              type     = "LOWERCASE"
            }
          }
        }
        statement {
          not_statement {
            statement {
              geo_match_statement {
                country_codes = ["CA", "US"]
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CanadaUSOnlyGeoRestriction"
      sampled_requests_enabled   = true
    }
  }

  # 25 WCU
  rule {
    name     = "PreventHostInjections"
    priority = 11

    statement {
      not_statement {
        statement {
          regex_pattern_set_reference_statement {

            arn = var.notification_base_url_regex_arn

            field_to_match {
              single_header {
                name = "host"
              }
            }

            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
      }
    }

    action {
      block {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "PreventHostInjections"
      sampled_requests_enabled   = true
    }
  }

  # 20 WCU
  rule {
    name     = "SigninRateLimitRule"
    priority = 5

    action {
      block {
        custom_response {
          response_code = 429
          response_header {
            name  = "waf-block"
            value = "RateLimitRestriction"
          }
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SigninRule"
      sampled_requests_enabled   = true
    }
    statement {
      rate_based_statement {
        limit              = var.sign_in_waf_rate_limit
        aggregate_key_type = "IP"
        scope_down_statement {

          or_statement {

            statement {
              byte_match_statement {
                field_to_match {
                  uri_path {}
                }
                positional_constraint = "STARTS_WITH"
                search_string         = "/sign-in"
                text_transformation {
                  type     = "LOWERCASE"
                  priority = 0
                }
              }
            }
            statement {
              byte_match_statement {
                field_to_match {
                  uri_path {}
                }
                positional_constraint = "STARTS_WITH"
                search_string         = "/register"
                text_transformation {
                  type     = "LOWERCASE"
                  priority = 1
                }
              }
            }
            statement {
              byte_match_statement {
                field_to_match {
                  uri_path {}
                }
                positional_constraint = "STARTS_WITH"
                search_string         = "/forgot-password"
                text_transformation {
                  type     = "LOWERCASE"
                  priority = 2
                }
              }
            }
            statement {
              byte_match_statement {
                field_to_match {
                  uri_path {}
                }
                positional_constraint = "STARTS_WITH"
                search_string         = "/forced-password-reset"
                text_transformation {
                  type     = "LOWERCASE"
                  priority = 2
                }
              }
            }
          }
        }
      }
    }
  }

  # 26 WCU
  rule {
    name     = "rate_limit_all_except_api"
    priority = 13

    action {
      block {
        custom_response {
          response_code = 429
          response_header {
            name  = "waf-block"
            value = "RateLimitRestriction"
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "NonApiRateLimit"
      sampled_requests_enabled   = true
    }

    statement {
      rate_based_statement {
        limit              = var.non_api_waf_rate_limit
        aggregate_key_type = "IP"
        scope_down_statement {
          and_statement {
            statement {
              not_statement {
                statement {
                  byte_match_statement {
                    positional_constraint = "EXACTLY"
                    search_string         = var.waf_secret
                    field_to_match {
                      single_header {
                        name = "waf-secret"
                      }
                    }
                    text_transformation {
                      priority = 1
                      type     = "NONE"
                    }
                  }
                }
              }
            }
            statement {
              not_statement {
                statement {
                  byte_match_statement {
                    positional_constraint = "STARTS_WITH"
                    field_to_match {
                      single_header {
                        name = "host"
                      }
                    }
                    search_string = "api"
                    text_transformation {
                      priority = 1
                      type     = "COMPRESS_WHITE_SPACE"
                    }
                    text_transformation {
                      priority = 2
                      type     = "LOWERCASE"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  # 26 WCU
  rule {
    name     = "ApiRateLimit"
    priority = 14

    action {
      block {
        custom_response {
          response_code = 429
          response_header {
            name  = "waf-block"
            value = "RateLimitRestriction"
          }
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "ApiRateLimit"
      sampled_requests_enabled   = true
    }
    statement {
      rate_based_statement {
        limit              = var.api_waf_rate_limit
        aggregate_key_type = "IP"
        scope_down_statement {
          and_statement {
            statement {
              byte_match_statement {
                positional_constraint = "STARTS_WITH"
                field_to_match {
                  single_header {
                    name = "host"
                  }
                }
                search_string = "api"
                text_transformation {
                  priority = 1
                  type     = "COMPRESS_WHITE_SPACE"
                }
                text_transformation {
                  priority = 2
                  type     = "LOWERCASE"
                }
              }
            }
            statement {
              not_statement {
                statement {
                  byte_match_statement {
                    positional_constraint = "EXACTLY"
                    field_to_match {
                      single_header {
                        name = "waf-secret"
                      }
                    }
                    search_string = var.waf_secret
                    text_transformation {
                      priority = 1
                      type     = "NONE"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  # 157 WCU
  rule {
    name     = "valid_paths"
    priority = 17

    action {
      block {
        custom_response {
          response_code = 204
          response_header {
            name  = "Strict-Transport-Security"
            value = "max-age=63072000; includeSubDomains; preload"
          }
          response_header {
            name  = "Cross-Origin-Resource-Policy"
            value = "same-origin"
          }
        }
      }
    }

    statement {
      and_statement {
        # filter out non-matching paths for document download api
        statement {
          not_statement {
            statement {
              regex_pattern_set_reference_statement {
                arn = var.re_api_arn
                field_to_match {
                  uri_path {}
                }
                text_transformation {
                  priority = 1
                  type     = "COMPRESS_WHITE_SPACE"
                }
                text_transformation {
                  priority = 2
                  type     = "LOWERCASE"
                }
              }
            }
          }
        }

        statement {
          not_statement {
            statement {
              regex_pattern_set_reference_statement {
                arn = var.re_document_download_arn
                field_to_match {
                  uri_path {}
                }
                text_transformation {
                  priority = 1
                  type     = "COMPRESS_WHITE_SPACE"
                }
                text_transformation {
                  priority = 2
                  type     = "LOWERCASE"
                }
              }
            }
          }
        }

        statement {
          not_statement {
            statement {
              regex_pattern_set_reference_statement {
                arn = var.re_documentation_arn
                field_to_match {
                  uri_path {}
                }
                text_transformation {
                  priority = 1
                  type     = "COMPRESS_WHITE_SPACE"
                }
                text_transformation {
                  priority = 2
                  type     = "LOWERCASE"
                }
              }
            }
          }
        }

        # filter out non-matching paths for admin
        statement {
          not_statement {
            statement {
              regex_pattern_set_reference_statement {
                arn = var.re_admin_arn
                field_to_match {
                  uri_path {}
                }
                text_transformation {
                  priority = 1
                  type     = "COMPRESS_WHITE_SPACE"
                }
                text_transformation {
                  priority = 2
                  type     = "LOWERCASE"
                }
              }
            }
          }
        }
        statement {
          not_statement {
            statement {
              regex_pattern_set_reference_statement {
                arn = var.re_admin_arn2
                field_to_match {
                  uri_path {}
                }
                text_transformation {
                  priority = 1
                  type     = "COMPRESS_WHITE_SPACE"
                }
                text_transformation {
                  priority = 2
                  type     = "LOWERCASE"
                }
              }
            }
          }
        }
        statement {
          not_statement {
            statement {
              byte_match_statement {
                field_to_match {
                  uri_path {}
                }
                positional_constraint = "EXACTLY"
                search_string         = "/"
                text_transformation {
                  type     = "LOWERCASE"
                  priority = 0
                }
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "valid_paths"
      sampled_requests_enabled   = true
    }
  }

  # Use a bunch of AWS managed rules
  # See https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html

  # ~10 WCU - Block requests with oversized cookies or headers.
  # No path exclusions needed: legitimate use cases (including file uploads) do not require large cookies or headers.
  rule {
    name     = "BlockLargeRequests_CookiesAndHeaders"
    priority = 2

    action {
      count {}
    }

    statement {
      or_statement {
        statement {
          size_constraint_statement {
            field_to_match {
              cookies {
                match_pattern {
                  all {}
                }
                match_scope       = "ALL"
                oversize_handling = "MATCH"
              }
            }
            comparison_operator = "GT"
            size                = 8192
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
        statement {
          size_constraint_statement {
            field_to_match {
              headers {
                match_pattern {
                  all {}
                }
                match_scope       = "ALL"
                oversize_handling = "MATCH"
              }
            }
            comparison_operator = "GT"
            size                = 8192
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockLargeRequests_CookiesAndHeaders"
      sampled_requests_enabled   = true
    }
  }

  # ~15 WCU - Block requests with oversized bodies, excluding file upload and bulk-send paths.
  # Upload paths: CSV sends, template attachments, letter PDF validation, email branding logos,
  #               inline bulk notification JSON (/v2/notifications/bulk).
  # AWS WAF nesting limit (3 operator levels) requires body size and cookie/header size in separate rules.
  rule {
    name     = "BlockLargeRequests_Body"
    priority = 3

    action {
      count {}
    }

    statement {
      and_statement {
        statement {
          size_constraint_statement {
            field_to_match {
              body {
                oversize_handling = "MATCH"
              }
            }
            comparison_operator = "GT"
            size                = 8192
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
        statement {
          not_statement {
            statement {
              or_statement {
                # CSV bulk send and per-service file uploads (attachments, branding, letter PDFs)
                statement {
                  byte_match_statement {
                    field_to_match {
                      uri_path {}
                    }
                    positional_constraint = "STARTS_WITH"
                    search_string         = "/services/"
                    text_transformation {
                      priority = 0
                      type     = "LOWERCASE"
                    }
                  }
                }
                # Email branding logo uploads
                statement {
                  byte_match_statement {
                    field_to_match {
                      uri_path {}
                    }
                    positional_constraint = "STARTS_WITH"
                    search_string         = "/email-branding/"
                    text_transformation {
                      priority = 0
                      type     = "LOWERCASE"
                    }
                  }
                }
                # Platform admin PDF letter validation
                statement {
                  byte_match_statement {
                    field_to_match {
                      uri_path {}
                    }
                    positional_constraint = "STARTS_WITH"
                    search_string         = "/platform-admin/letter-validation-preview"
                    text_transformation {
                      priority = 0
                      type     = "LOWERCASE"
                    }
                  }
                }
                # Inline bulk notification JSON body (can be large with many recipients)
                statement {
                  byte_match_statement {
                    field_to_match {
                      uri_path {}
                    }
                    positional_constraint = "STARTS_WITH"
                    search_string         = "/v2/notifications/bulk"
                    text_transformation {
                      priority = 0
                      type     = "LOWERCASE"
                    }
                  }
                }
                # Letter PDF uploads
                statement {
                  byte_match_statement {
                    field_to_match {
                      uri_path {}
                    }
                    positional_constraint = "STARTS_WITH"
                    search_string         = "/letters"
                    text_transformation {
                      priority = 0
                      type     = "LOWERCASE"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockLargeRequests_Body"
      sampled_requests_enabled   = true
    }
  }

  # ~22 WCU - JA4 fingerprint rate limit on sign-in paths; catches credential-stuffing tools that rotate IPs
  # Count-only until baseline is established.
  rule {
    name     = "SigninRateLimitRule_JA4"
    priority = 6

    action {
      count {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SigninRateLimitRule_JA4"
      sampled_requests_enabled   = true
    }

    statement {
      rate_based_statement {
        limit              = var.sign_in_ja4_waf_rate_limit
        aggregate_key_type = "CUSTOM_KEYS"
        custom_key {
          ja4_fingerprint {
            fallback_behavior = "NO_MATCH"
          }
        }
        scope_down_statement {
          or_statement {
            statement {
              byte_match_statement {
                field_to_match {
                  uri_path {}
                }
                positional_constraint = "STARTS_WITH"
                search_string         = "/sign-in"
                text_transformation {
                  type     = "LOWERCASE"
                  priority = 0
                }
              }
            }
            statement {
              byte_match_statement {
                field_to_match {
                  uri_path {}
                }
                positional_constraint = "STARTS_WITH"
                search_string         = "/register"
                text_transformation {
                  type     = "LOWERCASE"
                  priority = 1
                }
              }
            }
            statement {
              byte_match_statement {
                field_to_match {
                  uri_path {}
                }
                positional_constraint = "STARTS_WITH"
                search_string         = "/forgot-password"
                text_transformation {
                  type     = "LOWERCASE"
                  priority = 2
                }
              }
            }
            statement {
              byte_match_statement {
                field_to_match {
                  uri_path {}
                }
                positional_constraint = "STARTS_WITH"
                search_string         = "/forced-password-reset"
                text_transformation {
                  type     = "LOWERCASE"
                  priority = 3
                }
              }
            }
          }
        }
      }
    }
  }

  # ~22 WCU - JA4 fingerprint rate limit on the API host; catches API abuse tools that rotate IPs
  # Count-only until baseline is established.
  rule {
    name     = "ApiRateLimit_JA4"
    priority = 7

    action {
      count {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "ApiRateLimit_JA4"
      sampled_requests_enabled   = true
    }

    statement {
      rate_based_statement {
        limit              = var.api_ja4_waf_rate_limit
        aggregate_key_type = "CUSTOM_KEYS"
        custom_key {
          ja4_fingerprint {
            fallback_behavior = "NO_MATCH"
          }
        }
        scope_down_statement {
          and_statement {
            statement {
              byte_match_statement {
                positional_constraint = "STARTS_WITH"
                field_to_match {
                  single_header {
                    name = "host"
                  }
                }
                search_string = "api"
                text_transformation {
                  priority = 1
                  type     = "COMPRESS_WHITE_SPACE"
                }
                text_transformation {
                  priority = 2
                  type     = "LOWERCASE"
                }
              }
            }
            statement {
              not_statement {
                statement {
                  byte_match_statement {
                    positional_constraint = "EXACTLY"
                    field_to_match {
                      single_header {
                        name = "waf-secret"
                      }
                    }
                    search_string = var.waf_secret
                    text_transformation {
                      priority = 1
                      type     = "NONE"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  # ~24 WCU - IP rate limit on mutating methods (POST/PUT/PATCH/DELETE) to the API host.
  # Lower threshold than ApiRateLimit to catch write-heavy abuse. Count-only until baseline established.
  rule {
    name     = "MutatingApiRateLimit"
    priority = 9

    action {
      count {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "MutatingApiRateLimit"
      sampled_requests_enabled   = true
    }

    statement {
      rate_based_statement {
        limit              = var.api_mutating_waf_rate_limit
        aggregate_key_type = "IP"
        scope_down_statement {
          and_statement {
            statement {
              byte_match_statement {
                positional_constraint = "STARTS_WITH"
                field_to_match {
                  single_header {
                    name = "host"
                  }
                }
                search_string = "api"
                text_transformation {
                  priority = 1
                  type     = "COMPRESS_WHITE_SPACE"
                }
                text_transformation {
                  priority = 2
                  type     = "LOWERCASE"
                }
              }
            }
            statement {
              not_statement {
                statement {
                  byte_match_statement {
                    positional_constraint = "EXACTLY"
                    field_to_match {
                      single_header {
                        name = "waf-secret"
                      }
                    }
                    search_string = var.waf_secret
                    text_transformation {
                      priority = 1
                      type     = "NONE"
                    }
                  }
                }
              }
            }
            statement {
              regex_match_statement {
                field_to_match {
                  method {}
                }
                regex_string = "^(delete|patch|post|put)$"
                text_transformation {
                  priority = 0
                  type     = "LOWERCASE"
                }
              }
            }
          }
        }
      }
    }
  }

  # ~24 WCU - JA4 rate limit on mutating methods; catches write-abuse tools that rotate IPs.
  # Count-only until baseline established.
  rule {
    name     = "MutatingApiRateLimit_JA4"
    priority = 10

    action {
      count {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "MutatingApiRateLimit_JA4"
      sampled_requests_enabled   = true
    }

    statement {
      rate_based_statement {
        limit              = var.api_mutating_ja4_waf_rate_limit
        aggregate_key_type = "CUSTOM_KEYS"
        custom_key {
          ja4_fingerprint {
            fallback_behavior = "NO_MATCH"
          }
        }
        scope_down_statement {
          and_statement {
            statement {
              byte_match_statement {
                positional_constraint = "STARTS_WITH"
                field_to_match {
                  single_header {
                    name = "host"
                  }
                }
                search_string = "api"
                text_transformation {
                  priority = 1
                  type     = "COMPRESS_WHITE_SPACE"
                }
                text_transformation {
                  priority = 2
                  type     = "LOWERCASE"
                }
              }
            }
            statement {
              not_statement {
                statement {
                  byte_match_statement {
                    positional_constraint = "EXACTLY"
                    field_to_match {
                      single_header {
                        name = "waf-secret"
                      }
                    }
                    search_string = var.waf_secret
                    text_transformation {
                      priority = 1
                      type     = "NONE"
                    }
                  }
                }
              }
            }
            statement {
              regex_match_statement {
                field_to_match {
                  method {}
                }
                regex_string = "^(delete|patch|post|put)$"
                text_transformation {
                  priority = 0
                  type     = "LOWERCASE"
                }
              }
            }
          }
        }
      }
    }
  }

  # 25 WCU
  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 12

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  # ~30 WCU - Block non-CA access to authenticated admin pages.
  # Public pages (sign-in, register, auth flows, GCA content, contact, newsletter, /_status) remain accessible worldwide.
  rule {
    name     = "AdminAuthenticatedPagesGeoRestriction"
    priority = 15

    action {
      count {}
    }

    statement {
      and_statement {
        statement {
          not_statement {
            statement {
              geo_match_statement {
                country_codes = ["CA"]
              }
            }
          }
        }
        statement {
          or_statement {
            statement {
              byte_match_statement {
                field_to_match {
                  uri_path {}
                }
                positional_constraint = "STARTS_WITH"
                search_string         = "/services/"
                text_transformation {
                  priority = 0
                  type     = "LOWERCASE"
                }
              }
            }
            statement {
              byte_match_statement {
                field_to_match {
                  uri_path {}
                }
                positional_constraint = "STARTS_WITH"
                search_string         = "/organisations/"
                text_transformation {
                  priority = 0
                  type     = "LOWERCASE"
                }
              }
            }
            statement {
              byte_match_statement {
                field_to_match {
                  uri_path {}
                }
                positional_constraint = "STARTS_WITH"
                search_string         = "/platform-admin/"
                text_transformation {
                  priority = 0
                  type     = "LOWERCASE"
                }
              }
            }
            statement {
              byte_match_statement {
                field_to_match {
                  uri_path {}
                }
                positional_constraint = "STARTS_WITH"
                search_string         = "/user-profile"
                text_transformation {
                  priority = 0
                  type     = "LOWERCASE"
                }
              }
            }
            statement {
              byte_match_statement {
                field_to_match {
                  uri_path {}
                }
                positional_constraint = "STARTS_WITH"
                search_string         = "/find-users-by-email"
                text_transformation {
                  priority = 0
                  type     = "LOWERCASE"
                }
              }
            }
            statement {
              byte_match_statement {
                field_to_match {
                  uri_path {}
                }
                positional_constraint = "STARTS_WITH"
                search_string         = "/accounts"
                text_transformation {
                  priority = 0
                  type     = "LOWERCASE"
                }
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AdminAuthenticatedPagesGeoRestriction"
      sampled_requests_enabled   = true
    }
  }

  # 50 WCU
  rule {
    name     = "AWSManagedRulesAnonymousIpList"
    priority = 16

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"

        rule_action_override {
          name = "HostingProviderIPList"
          action_to_use {
            count {}
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAnonymousIpList"
      sampled_requests_enabled   = true
    }
  }

  # 200 WCU
  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 18

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # 200 WCU
  rule {
    name     = "AWSManagedRulesLinuxRuleSet"
    priority = 19

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesLinuxRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # 700 WCU
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 20

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        rule_action_override {
          name = "CrossSiteScripting_BODY"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "EC2MetaDataSSRF_BODY"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "NoUserAgent_HEADER"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "SizeRestrictions_BODY"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "GenericLFI_BODY"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "GenericRFI_BODY"
          action_to_use {
            count {}
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # ~3 WCU - Block non-CA requests that were labelled by EC2MetaDataSSRF_BODY or NoUserAgent_HEADER
  # Must run after AWSManagedRulesCommonRuleSet (priority 20) so the labels exist.
  rule {
    name     = "BlockLabeled_SSRF_NoUserAgent_NonCA"
    priority = 21

    action {
      count {}
    }

    statement {
      and_statement {
        statement {
          or_statement {
            statement {
              label_match_statement {
                scope = "LABEL"
                key   = "awswaf:managed:aws:core-rule-set:EC2MetaDataSSRF_BODY"
              }
            }
            statement {
              label_match_statement {
                scope = "LABEL"
                key   = "awswaf:managed:aws:core-rule-set:NoUserAgent_HEADER"
              }
            }
          }
        }
        statement {
          not_statement {
            statement {
              geo_match_statement {
                country_codes = ["CA"]
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockLabeled_SSRF_NoUserAgent_NonCA"
      sampled_requests_enabled   = true
    }
  }

  # ~6 WCU - Block oversized bodies, except on bulk-send and file upload endpoints
  rule {
    name     = "BlockSizeRestrictions_Body_ExcludeUploadPaths"
    priority = 22

    action {
      count {}
    }

    statement {
      and_statement {
        statement {
          label_match_statement {
            scope = "LABEL"
            key   = "awswaf:managed:aws:core-rule-set:SizeRestrictions_BODY"
          }
        }
        statement {
          not_statement {
            statement {
              or_statement {
                # Bulk notification send
                statement {
                  byte_match_statement {
                    field_to_match {
                      uri_path {}
                    }
                    positional_constraint = "STARTS_WITH"
                    search_string         = "/v2/notifications/bulk"
                    text_transformation {
                      priority = 0
                      type     = "LOWERCASE"
                    }
                  }
                }
                # Document / file upload
                statement {
                  byte_match_statement {
                    field_to_match {
                      uri_path {}
                    }
                    positional_constraint = "STARTS_WITH"
                    search_string         = "/services/"
                    text_transformation {
                      priority = 0
                      type     = "LOWERCASE"
                    }
                  }
                }
                # Letter uploads (PDFs can be large)
                statement {
                  byte_match_statement {
                    field_to_match {
                      uri_path {}
                    }
                    positional_constraint = "STARTS_WITH"
                    search_string         = "/letters"
                    text_transformation {
                      priority = 0
                      type     = "LOWERCASE"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockSizeRestrictions_Body_ExcludeUploadPaths"
      sampled_requests_enabled   = true
    }
  }

  # ~6 WCU - Block LFI in body, except on template/notification paths where file-like strings are valid content
  rule {
    name     = "BlockLFI_Body_ExcludeTemplatePaths"
    priority = 23

    action {
      count {}
    }

    statement {
      and_statement {
        statement {
          label_match_statement {
            scope = "LABEL"
            key   = "awswaf:managed:aws:core-rule-set:GenericLFI_BODY"
          }
        }
        statement {
          not_statement {
            statement {
              or_statement {
                statement {
                  byte_match_statement {
                    field_to_match {
                      uri_path {}
                    }
                    positional_constraint = "STARTS_WITH"
                    search_string         = "/v2/notifications"
                    text_transformation {
                      priority = 0
                      type     = "LOWERCASE"
                    }
                  }
                }
                statement {
                  byte_match_statement {
                    field_to_match {
                      uri_path {}
                    }
                    positional_constraint = "STARTS_WITH"
                    search_string         = "/templates"
                    text_transformation {
                      priority = 0
                      type     = "LOWERCASE"
                    }
                  }
                }
                statement {
                  byte_match_statement {
                    field_to_match {
                      uri_path {}
                    }
                    positional_constraint = "STARTS_WITH"
                    search_string         = "/personalise"
                    text_transformation {
                      priority = 0
                      type     = "LOWERCASE"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockLFI_Body_ExcludeTemplatePaths"
      sampled_requests_enabled   = true
    }
  }

  # ~8 WCU - Block XSS in body, except on paths where users legitimately send HTML/template content:
  # /v2/notifications (email body), /templates, /personalise, /_email, /_letter (preview rendering)
  rule {
    name     = "BlockXSS_Body_ExcludeContentPaths"
    priority = 24

    action {
      count {}
    }

    statement {
      and_statement {
        statement {
          label_match_statement {
            scope = "LABEL"
            key   = "awswaf:managed:aws:core-rule-set:CrossSiteScripting_BODY"
          }
        }
        statement {
          not_statement {
            statement {
              or_statement {
                statement {
                  byte_match_statement {
                    field_to_match {
                      uri_path {}
                    }
                    positional_constraint = "STARTS_WITH"
                    search_string         = "/v2/notifications"
                    text_transformation {
                      priority = 0
                      type     = "LOWERCASE"
                    }
                  }
                }
                statement {
                  byte_match_statement {
                    field_to_match {
                      uri_path {}
                    }
                    positional_constraint = "STARTS_WITH"
                    search_string         = "/templates"
                    text_transformation {
                      priority = 0
                      type     = "LOWERCASE"
                    }
                  }
                }
                statement {
                  byte_match_statement {
                    field_to_match {
                      uri_path {}
                    }
                    positional_constraint = "STARTS_WITH"
                    search_string         = "/personalise"
                    text_transformation {
                      priority = 0
                      type     = "LOWERCASE"
                    }
                  }
                }
                statement {
                  byte_match_statement {
                    field_to_match {
                      uri_path {}
                    }
                    positional_constraint = "STARTS_WITH"
                    search_string         = "/_email"
                    text_transformation {
                      priority = 0
                      type     = "LOWERCASE"
                    }
                  }
                }
                statement {
                  byte_match_statement {
                    field_to_match {
                      uri_path {}
                    }
                    positional_constraint = "STARTS_WITH"
                    search_string         = "/_letter"
                    text_transformation {
                      priority = 0
                      type     = "LOWERCASE"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockXSS_Body_ExcludeContentPaths"
      sampled_requests_enabled   = true
    }
  }

  # 200 WCU
  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 25

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"

        # Notification/template bodies can contain SQL-like text (e.g. "SELECT your plan").
        # Override to count so labels are set for the follow-up label-match rule below,
        # which applies path-based exclusions before blocking.
        rule_action_override {
          name = "SQLi_BODY"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "SQLiExtendedPatterns_Body"
          action_to_use {
            count {}
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # ~6 WCU - Block SQLi in body except on paths where user-supplied content is expected.
  # Count-only until baseline established. Must run after AWSManagedRulesSQLiRuleSet (priority 25).
  rule {
    name     = "BlockSQLi_Body_ExcludeContentPaths"
    priority = 26

    action {
      count {}
    }

    statement {
      and_statement {
        statement {
          or_statement {
            statement {
              label_match_statement {
                scope = "LABEL"
                key   = "awswaf:managed:aws:sql-database:SQLi_Body"
              }
            }
            statement {
              label_match_statement {
                scope = "LABEL"
                key   = "awswaf:managed:aws:sql-database:SQLiExtendedPatterns_Body"
              }
            }
          }
        }
        statement {
          not_statement {
            statement {
              or_statement {
                statement {
                  byte_match_statement {
                    field_to_match {
                      uri_path {}
                    }
                    positional_constraint = "STARTS_WITH"
                    search_string         = "/v2/notifications"
                    text_transformation {
                      priority = 0
                      type     = "LOWERCASE"
                    }
                  }
                }
                statement {
                  byte_match_statement {
                    field_to_match {
                      uri_path {}
                    }
                    positional_constraint = "STARTS_WITH"
                    search_string         = "/templates"
                    text_transformation {
                      priority = 0
                      type     = "LOWERCASE"
                    }
                  }
                }
                statement {
                  byte_match_statement {
                    field_to_match {
                      uri_path {}
                    }
                    positional_constraint = "STARTS_WITH"
                    search_string         = "/personalise"
                    text_transformation {
                      priority = 0
                      type     = "LOWERCASE"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockSQLi_Body_ExcludeContentPaths"
      sampled_requests_enabled   = true
    }
  }

  # Requires Shield Advanced. Uses Challenge action (silent JS browser check) to flag/mitigate L7 DDoS.
  # Running in count mode to baseline before enabling.
  # WARNING: ChallengeAllDuringEvent challenges ALL traffic during an active Shield DDoS event,
  # including API clients that cannot complete a JS challenge. Do not switch to block without
  # scoping this rule to non-API hosts, or risk breaking API consumers during incidents.
  rule {
    name     = "AWSManagedRulesAntiDDoSRuleSet"
    priority = 27

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAntiDDoSRuleSet"
        vendor_name = "AWS"

        managed_rule_group_configs {
          aws_managed_rules_anti_ddos_rule_set {
            client_side_action_config {
              challenge {
                usage_of_action = "ENABLED"
                sensitivity     = "HIGH"
                # Paths that cannot complete a silent JS challenge (automated/non-browser callers).
                # The API host is already excluded via scope_down_statement above.
                exempt_uri_regular_expression {
                  regex_string = "^/_status"
                }
              }
            }
            sensitivity_to_block = "HIGH"
          }
        }

        # Exclude API hosts: JS Challenge action cannot be completed by automated API clients.
        scope_down_statement {
          not_statement {
            statement {
              byte_match_statement {
                field_to_match {
                  single_header {
                    name = "host"
                  }
                }
                positional_constraint = "STARTS_WITH"
                search_string         = "api"
                text_transformation {
                  priority = 0
                  type     = "LOWERCASE"
                }
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAntiDDoSRuleSet"
      sampled_requests_enabled   = true
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

#
# WAF logging to Cloud Based Sensor satellite bucket
#
resource "aws_kinesis_firehose_delivery_stream" "firehose-waf-logs" {
  provider    = aws.core_services
  name        = "aws-waf-logs-notification-canada-ca-waf"
  destination = "extended_s3"

  server_side_encryption {
    enabled = true
  }

  extended_s3_configuration {
    role_arn           = var.firehose_waf_logs_iam_role_arn
    prefix             = "waf_acl_logs/AWSLogs/${var.account_id}/lb/"
    bucket_arn         = "arn:aws:s3:::${var.cbs_satellite_bucket_name}"
    compression_format = "GZIP"

    # Buffer incoming data size (MB), before delivering to S3 bucket
    # Should be greater than amount of data ingested in a 10 second period
    buffering_size = 5
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
    Terraform  = true
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "firehose-waf-logs" {
  provider                = aws.core_services
  log_destination_configs = [aws_kinesis_firehose_delivery_stream.firehose-waf-logs.arn]
  resource_arn            = aws_wafv2_web_acl.notification-canada-ca.arn

  redacted_fields {
    single_header {
      name = "authorization"
    }
  }
}
