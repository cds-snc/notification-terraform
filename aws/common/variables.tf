variable "newrelic_account_region" {
  type    = string
  default = "US"

  validation {
    condition     = contains(["US", "EU"], var.newrelic_account_region)
    error_message = "Valid values for region are 'US' or 'EU'."
  }
}

variable "vpc_ids" {
  type        = list(string)
  description = "List of VPC IDs to enable Route53 resolver query logging"
  default     = []
}
