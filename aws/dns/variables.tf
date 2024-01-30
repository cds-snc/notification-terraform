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
  default     = "\"AWS\": \"419291849580\", \"AWS\": \"239043911459\", \"AWS\": \"296255494825\""
}

variable "route_53_zone_arn" {
  type        = string
  description = "Used by the scratch environment to reference cdssandbox in staging"
  default     = "/hostedzone/Z04028033PLSHVOO9ZJ1Z"
}

variable "vpc_id" {
  type        = string
  description = "Used to associate the internal DNS with the VPC"
}