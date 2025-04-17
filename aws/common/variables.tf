variable "newrelic_account_region" {
  type    = string
  default = "US"

  validation {
    condition     = contains(["US", "EU"], var.newrelic_account_region)
    error_message = "Valid values for region are 'US' or 'EU'."
  }
}

variable "ses_receipt_callback_buffer_arn" {
  description = "ARN of the SES receipt callback buffer SQS queue"
  type        = string
}