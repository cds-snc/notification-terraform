
# This is hack'ish as we're cloning an external repo into a temp directory so that we can populate CloudFront.
# We will have to review a better way of doing this in the future, but our long term goal of having one source of
# truth for the assets is accomplished.

resource "aws_s3_object" "assets" {

  bucket   = aws_s3_bucket.asset_bucket.id
  for_each = fileset("/var/tmp/notification-admin/app/assets/cloudfront", "**")
  key      = each.value
  source   = "/var/tmp/notification-admin/app/assets/cloudfront/${each.value}"
  content_type = "image/svg+xml"

}