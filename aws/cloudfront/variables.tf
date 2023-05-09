variable "asset_bucket_regional_domain_name" {
  type = string
}

variable "s3_bucket_asset_bucket_id" {
  type = string
}

variable "s3_bucket_asset_bucket_arn" {
  type = string
}
variable "route_53_zone_arn" {
  type        = string
  description = "Used by the scratch environment to reference cdssandbox in staging"
  default     = "/hostedzone/Z04028033PLSHVOO9ZJ1Z"
}