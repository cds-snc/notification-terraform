resource "aws_s3_object" "assets" {

    bucket = aws_s3_bucket.asset_bucket.id
    for_each = fileset("/var/tmp/notification-admin/app/assets/cloudfront","**")
    key = each.value
    source = "/var/tmp/notification-admin/app/assets/cloudfront/${each.value}"
}