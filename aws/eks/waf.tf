resource "aws_wafv2_web_acl" "notification-canada-ca" {
  name  = "notification-canada-ca-waf"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  # Use a bunch of AWS managed rules
  # See https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html
  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 1

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

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        excluded_rule {
          name = "CrossSiteScripting_BODY"
        }
        # TODO: Use the label generated by this rule + traffic not from Canada to block in a subsequent rule.
        excluded_rule {
          name = "EC2MetaDataSSRF_BODY"
        }
        excluded_rule {
          name = "NoUserAgent_HEADER"
        }
        excluded_rule {
          name = "SizeRestrictions_BODY"
        }
        excluded_rule {
          name = "GenericLFI_BODY"
        }

        excluded_rule {
          name = "GenericRFI_BODY"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 3

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

  rule {
    name     = "AWSManagedRulesLinuxRuleSet"
    priority = 4

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

  rule {
    name     = "AWSManagedRulesAnonymousIpList"
    priority = 5

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"

        excluded_rule {
          name = "HostingProviderIPList"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAnonymousIpList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesBotControlRuleSet"
    priority = 6

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesBotControlRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "SigninRateLimitRule"
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

  rule {
    name     = "valid_paths"
    priority = 10

    action {
      block {
        custom_response {
          response_code = 204
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

  rule {
    name     = "CanadaUSOnlyGeoRestriction"
    priority = 20

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

  rule {
    name     = "rate_limit_all_except_api"
    priority = 200

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

  rule {
    name     = "ApiRateLimit"
    priority = 210

    action {
      count {}
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

  rule {
    name     = "ip_blocklist"
    priority = 8

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
    buffer_size = 5
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
    Terraform  = true
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "firehose-waf-logs" {
  log_destination_configs = [aws_kinesis_firehose_delivery_stream.firehose-waf-logs.arn]
  resource_arn            = aws_wafv2_web_acl.notification-canada-ca.arn

  redacted_fields {
    single_header {
      name = "authorization"
    }
  }
}
