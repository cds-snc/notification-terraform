variable "newrelic_account_region" {
  type    = string
  default = "US"

  validation {
    condition     = contains(["US", "EU"], var.newrelic_account_region)
    error_message = "Valid values for region are 'US' or 'EU'."
  }
}

variable "dns_failure_threshold" {
  type        = number
  description = "The threshold for DNS resolution failures before triggering an alarm"
  default     = 5 # Adjust this default value based on your requirements
}

variable "vpc_ids" {
  type        = list(string)
  description = "List of VPC IDs to enable Route53 resolver query logging"
  default     = []
}
