variable "newrelic_account_region" {
  type    = string
  default = "US"

  validation {
    condition     = contains(["US", "EU"], var.newrelic_account_region)
    error_message = "Valid values for region are 'US' or 'EU'."
  }
}

variable "aws_config_recorder_name" {
  type        = string
  description = "The name of the AWS Configuration Recorder"
  default     = "aws-controltower-BaselineConfigRecorder"
}
