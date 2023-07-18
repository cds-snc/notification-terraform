variable "scratch_account_ids" {
  type        = string
  description = "Used by staging DNS zone to set up cross account IAM"
  default     = "\"AWS\": \"419291849580\", \"AWS\": \"239043911459\", \"AWS\": \"296255494825\""
}

variable "route53_zone_arn" {
  type        = string
  description = "Used by the scratch environment to reference cdssandbox in staging"
  default     = "/hostedzone/Z04028033PLSHVOO9ZJ1Z"
}