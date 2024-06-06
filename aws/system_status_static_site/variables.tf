variable "route_53_zone_arn" {
  type        = string
  description = "Used by the scratch environment to reference cdssandbox in staging"
  default     = "/hostedzone/Z04028033PLSHVOO9ZJ1Z"
}

variable "status_cert_created" {
  type        = bool
  description = "This flag must be set to false on a new environment creation in production, so that we can generate the certificate first."
  default     = false
}

variable "force_destroy_s3" {
  type        = bool
  description = "Force destroy the s3 bucket. Not advised for production."
  default     = false
}