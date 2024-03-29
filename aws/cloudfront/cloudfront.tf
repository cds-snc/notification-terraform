resource "aws_cloudfront_origin_access_identity" "default" {
}

resource "aws_cloudfront_distribution" "asset_bucket" {

  origin {
    domain_name = var.asset_bucket_regional_domain_name
    origin_id   = "asset-cloudfront-${var.env}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "gov-canada-en.svg"

  aliases = ["assets.${var.domain}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "asset-cloudfront-${var.env}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 60 * 60 * 12
    max_ttl                = 60 * 60 * 24
    compress               = true
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.assets-notification-canada-ca.arn
    minimum_protocol_version = "TLSv1.2_2019"
    ssl_support_method       = "sni-only"
  }

  web_acl_id = aws_wafv2_web_acl.assets_cdn.arn

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }

  #tfsec:ignore:AWS071 - Access logging disabled
}
