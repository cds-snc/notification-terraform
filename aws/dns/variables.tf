variable "notification_canada_ca_ses_callback_arn" {
  type = string
}

variable "lambda_ses_receiving_emails_arn" {
  type = string
}

variable "ses_custom_sending_domains" {
  type = set(string)
}
