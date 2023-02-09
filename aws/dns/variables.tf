variable "notification_canada_ca_ses_callback_arn" {
  type = string
}

variable "ses_custom_sending_domains" {
  type = set(string)
}

variable "lambda_ses_receiving_emails_image_arn" {
  type = string
}
