variable "billing_tag_value" {
  type        = string
  description = "The value of the billing tag"

}

module "system_status_static_site" {
  source = "github.com/cds-snc/terraform-modules//simple_static_website?ref=v9.3.1"

  count = var.status_cert_created ? 1 : 0

  acm_certificate_arn                = aws_acm_certificate.system_status_static_site_root_certificate.arn
  domain_name_source                 = var.env == "production" ? "status.notification.canada.ca" : "status.${var.env}.notification.cdssandbox.xyz"
  billing_tag_value                  = var.billing_tag_value
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


resource "aws_acm_certificate" "system_status_static_site_root_certificate" {
  # Cloudfront requires client certificate to be created in us-east-1

  provider          = aws.us-east-1
  domain_name       = var.env == "production" ? "status.notification.canada.ca" : "status.${var.env}.notification.cdssandbox.xyz"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

# This can't happen in production because we don't own the DNS zone. A PR will have to be done to cds-snc/dns with the validation records obtained from the above.

resource "aws_acm_certificate_validation" "system_status_static_site" {
  count                   = var.env != "production" ? 1 : 0
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.system_status_static_site_root_certificate.arn
  validation_record_fqdns = [aws_route53_record.system_status_static_site[0].fqdn]
}

resource "aws_route53_record" "system_status_static_site" {
  count           = var.env != "production" ? 1 : 0
  provider        = aws.dns
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.system_status_static_site_root_certificate.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.system_status_static_site_root_certificate.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.system_status_static_site_root_certificate.domain_validation_options)[0].resource_record_type
  zone_id         = var.route_53_zone_arn
  ttl             = 60
}