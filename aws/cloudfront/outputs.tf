output "cloudfront_assets_arn" {
  value = aws_cloudfront_distribution.asset_bucket.arn
}

output "cloudfront_default_oai_arn" {
  value = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
}
