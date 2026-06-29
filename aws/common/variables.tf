variable "vpc_ids" {
  type        = list(string)
  description = "List of VPC IDs to enable Route53 resolver query logging"
  default     = []
}

variable "enable_guardduty_scan_api_destination" {
  type        = bool
  description = "Enable GuardDuty -> EventBridge -> API Destination callback for file scan verdicts"
  default     = false
}

variable "scan_verdict_callback_url" {
  type        = string
  description = "Public HTTPS endpoint for scan verdict callback. Required when enable_guardduty_scan_api_destination is true."
  default     = null

  validation {
    condition = !var.enable_guardduty_scan_api_destination || (
      var.scan_verdict_callback_url != null &&
      trimspace(var.scan_verdict_callback_url) != "" &&
      startswith(var.scan_verdict_callback_url, "https://")
    )
    error_message = "scan_verdict_callback_url must be a non-empty HTTPS URL when enable_guardduty_scan_api_destination is true."
  }
}

variable "scan_verdict_api_destination_rate_limit_per_second" {
  type        = number
  description = "API Destination invocation rate limit"
  default     = 10
}

variable "scan_verdict_event_retry_max_attempts" {
  type        = number
  description = "EventBridge retry max attempts for API Destination target"
  default     = 24
}

variable "scan_verdict_event_retry_max_age_seconds" {
  type        = number
  description = "EventBridge retry max event age in seconds"
  default     = 3600
}