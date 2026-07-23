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
    priority = 2

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
    priority = 3

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
    priority = 4

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
    priority = 6

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
    priority = 7

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
    priority = 8

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

  # 25 WCU
  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 9

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

  # 50 WCU
  rule {
    name     = "AWSManagedRulesAnonymousIpList"
    priority = 10

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
    priority = 11

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
    priority = 12

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
    priority = 13

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
        # TODO: Use the label generated by this rule + traffic not from Canada to block in a subsequent rule.
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
