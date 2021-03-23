# common resource between cloudfront and s3 bucket policy
resource "aws_cloudfront_origin_access_identity" "default" {
  comment = "cloudfront origin access identity"
}
