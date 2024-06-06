output "system_status_static_site_bucket_name" {
  value       = var.status_cert_created ? module.system_status_static_site[0].s3_bucket_arn : ""
  description = "name of the s3 bucket for the system status static site"
}

output "system_status_static_site_bucket_id" {
  value       = var.status_cert_created ? module.system_status_static_site[0].s3_bucket_id : ""
  description = "id of the s3 bucket for the system status static site"
}

output "system_status_static_site_bucket_region" {
  value       = var.status_cert_created ? module.system_status_static_site[0].s3_bucket_region : ""
  description = "aws region of the s3 bucket for the system status static site"
}