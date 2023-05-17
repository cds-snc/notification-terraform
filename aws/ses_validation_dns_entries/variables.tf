variable "scratch_account_ids" {
  type        = string
  description = "Used by staging DNS zone to set up cross account IAM"
  default     = "\"AWS\": \"419291849580\", \"AWS\": \"239043911459\", \"AWS\": \"296255494825\""
}

variable "route53_zone_arn" {
  type        = string
  description = "Used in non-staging environments to provide the DNS Zone ARN"
  default     = ""
}

variable "custom_sending_domains_dkim" {
  type        = string
  description = "Used to fetch the validation tokens for dkim for custom sending domains"
}

variable "cic_trvapply_vrtdemande_dkim" {
  type        = string
  description = "Used to fetch the validation tokens for dkim for cic trvapply"
}

variable "notification_canada_ca_dkim" {
  type        = string
  description = "Used to fetch the validation tokens for the root notify domain"
}