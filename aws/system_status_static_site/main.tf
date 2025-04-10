module "system_status_static_site" {
  source = "github.com/cds-snc/terraform-modules//simple_static_website?ref=v10.0.0"

  domain_name_source                 = var.env == "production" ? "status.notification.canada.ca" : "status.${var.env}.notification.cdssandbox.xyz"
  billing_tag_value                  = var.billing_tag_value
  hosted_zone_id                     = var.route53_zone_id
  is_create_hosted_zone              = false
  s3_bucket_name                     = "notification-canada-ca-${var.env}-system-status"
  force_destroy_s3_bucket            = true
  cloudfront_query_string_forwarding = true

  providers = {
    aws           = aws
    aws.us-east-1 = aws.us-east-1
    aws.dns       = aws.dns
  }
}
