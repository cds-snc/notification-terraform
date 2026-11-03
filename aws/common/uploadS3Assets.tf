
# This is hack'ish as we're cloning external repos into temp directories (see the hooks in env/*/common/terragrunt.hcl)
# so that we can populate CloudFront. We will have to review a better way of doing this in the future, but our long
# term goal of having one source of truth for the assets is accomplished.

locals {
  asset_content_types = {
    gif  = "image/gif"
    jpeg = "image/jpeg"
    jpg  = "image/jpeg"
    png  = "image/png"
    svg  = "image/svg+xml"
  }

  admin_assets_dir = "/var/tmp/notification-admin/app/assets/cloudfront"

  # Default email branding images (FIP signature, Canada wordmark, ...) from notification-utils.
  # They are published under content-addressed keys that must match notifications_utils/email_assets.py:
  #   email-assets/<name>-<first 10 hex characters of the file's sha256>.<extension>
  email_assets_dir = "/var/tmp/notification-utils/notifications_utils/static/email"
  email_assets = {
    for file in fileset(local.email_assets_dir, "*.{gif,jpeg,jpg,png,svg}") :
    "email-assets/${regex("^(.+)\\.([^.]+)$", file)[0]}-${substr(filesha256("${local.email_assets_dir}/${file}"), 0, 10)}.${regex("^(.+)\\.([^.]+)$", file)[1]}" => file
  }
}

resource "aws_s3_object" "assets" {

  bucket       = aws_s3_bucket.asset_bucket.id
  for_each     = fileset(local.admin_assets_dir, "**")
  key          = each.value
  source       = "${local.admin_assets_dir}/${each.value}"
  content_type = lookup(local.asset_content_types, lower(regex("[^.]+$", each.value)), "application/octet-stream")

}

# Uploaded with the AWS CLI rather than aws_s3_object so that objects are never deleted: when an image changes it gets
# a new key, and emails that have already been sent (and api/admin versions that are still deployed) keep referencing
# the old one. Removing an entry from this map only removes it from the Terraform state.
resource "terraform_data" "email_assets" {
  for_each = local.email_assets

  triggers_replace = {
    bucket = aws_s3_bucket.asset_bucket.id
    key    = each.key
  }

  provisioner "local-exec" {
    command = "aws s3 cp \"$SOURCE\" \"s3://$BUCKET/$KEY\" --region \"$REGION\" --content-type \"$CONTENT_TYPE\" --cache-control \"public, max-age=31536000, immutable\""
    environment = {
      SOURCE       = "${local.email_assets_dir}/${each.value}"
      BUCKET       = aws_s3_bucket.asset_bucket.id
      KEY          = each.key
      REGION       = var.region
      CONTENT_TYPE = local.asset_content_types[lower(regex("[^.]+$", each.value))]
    }
  }
}
