variable "custom_sending_domains_dkim" {
  type        = string
  description = "Used to fetch the validation tokens for dkim for custom sending domains"
}

variable "notification_canada_ca_dkim" {
  type        = string
  description = "Used to fetch the validation tokens for the root notify domain"
}

variable "notification_canada_ca_receiving_dkim" {
  type        = string
  description = "Used to fetch the validation tokens for the root notify domain in US-EAST-1"
}