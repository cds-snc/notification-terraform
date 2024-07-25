variable "new_relic_account_id" {
  type        = string
  description = "New Relic Account ID"
  sensitive   = true
}
variable "new_relic_api_key" {
  type        = string
  description = "New Relic API Key"
  sensitive   = true
}
variable "new_relic_slack_webhook_url" {
  type        = string
  description = "Slack Webhook URL"
  sensitive   = true
}

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