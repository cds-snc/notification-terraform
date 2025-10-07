output "system_status_static_site_bucket_name" {
  value       = module.system_status_static_site.s3_bucket_arn
  description = "name of the s3 bucket for the system status static site"
}

output "system_status_static_site_bucket_id" {
  value       = module.system_status_static_site.s3_bucket_id
  description = "id of the s3 bucket for the system status static site"
}

output "system_status_static_site_cloudfront_distribution" {
  value       = module.system_status_static_site.cloudfront_distribution_id
  description = "id of the cloudfront distribution for the system status static site"
}

output "system_status_static_site_bucket_region" {
  value       = module.system_status_static_site.s3_bucket_region
  description = "aws region of the s3 bucket for the system status static site"
}