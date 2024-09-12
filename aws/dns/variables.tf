variable "notification_canada_ca_ses_callback_arn" {
  type = string
}

variable "ses_custom_sending_domains" {
  type = set(string)
}

variable "lambda_ses_receiving_emails_image_arn" {
  type = string
}

variable "scratch_account_ids" {
  type        = string
  description = "Used by staging DNS zone to set up cross account IAM"
  sensitive   = true
}

variable "vpc_id" {
  type        = string
  description = "Used to associate the internal DNS with the VPC"
}

variable "hosted_zone_id" {
  type        = string
  description = "Used to associate the internal DNS with the VPC"
  default     = "Z04028033PLSHVOO9ZJ1Z"
}

variable "scratch_account_id" {
  type        = string
  description = "scratch account id"
  sensitive   = true
}

variable "production_account_id" {
  type        = string
  default     = var.production_account_id
  description = "production account id"
  sensitive   = true
}

variable "staging_account_id" {
  type        = string
  default     = var.staging_account_id
  description = "staging account id"
  sensitive   = true
}

variable "sandbox_account_id" {
  type        = string
  default     = var.sandbox_account_id
  description = "sandbox account id"
  sensitive   = true
}

variable "dev_account_id" {
  type        = string
  default     = var.dev_account_id
  description = "dev account id"
  sensitive   = true
}