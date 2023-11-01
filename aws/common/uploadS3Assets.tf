# This is a bit of a hack in that we're cloning an external repo into a temp directory so that we can populate cloudfront.
# We will have to review a better way of doing this in the future, but this will get us going in the right direction

resource "aws_s3_object" "assets" {

  bucket   = aws_s3_bucket.asset_bucket.id
  for_each = fileset("/var/tmp/notification-admin/app/assets/cloudfront", "**")
  key      = each.value
  source   = "/var/tmp/notification-admin/app/assets/cloudfront/${each.value}"
}