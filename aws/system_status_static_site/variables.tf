variable "route53_zone_id" {
  type        = string
  description = "Used by the scratch environment to reference cdssandbox in staging"
}

variable "force_destroy_s3" {
  type        = bool
  description = "Force destroy the s3 bucket. Not advised for production."
  default     = false
}