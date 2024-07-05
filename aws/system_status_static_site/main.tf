module "system_status_static_site" {
  source = "github.com/cds-snc/terraform-modules//simple_static_website?ref=v9.5.3"

  domain_name_source                 = var.env == "production" ? "status.notification.canada.ca" : "status.${var.env}.notification.cdssandbox.xyz"
  billing_tag_value                  = "notification-canada-ca-${var.env}"
  hosted_zone_id                     = var.route_53_zone_arn
  s3_bucket_name                     = "notification-canada-ca-${var.env}-system-status"
  force_destroy_s3_bucket            = true
  cloudfront_query_string_forwarding = true

  providers = {
    aws           = aws
    aws.us-east-1 = aws.us-east-1
    aws.dns       = aws.dns
  }
}