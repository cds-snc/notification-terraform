variable "newrelic_account_region" {
  type    = string
  default = "US"

  validation {
    condition     = contains(["US", "EU"], var.newrelic_account_region)
    error_message = "Valid values for region are 'US' or 'EU'."
  }
}

variable "dns_failure_threshold" {
  description = "Threshold for DNS resolution failures to trigger an alarm"
  type        = number
  default     = 5 # Adjust based on your specific requirements
}
