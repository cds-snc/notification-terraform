variable "notification_canada_ca_ses_callback_arn" {
  type = string
}

variable "lambda_ses_receiving_emails_image_arn" {
  type = string
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
