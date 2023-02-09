variable "billing_tag_value" {
  type        = string
  description = "Identifies the billing code."
}
variable "sns_alert_warning_arn" {
  type = string
}

variable "sns_alert_critical_arn" {
  type = string
}

variable "sns_deliveries_ca_cental" {
  type = string
}

variable "sns_deliveries_failures_ca_cental" {
  type = string
}

variable "sns_deliveries_us_west_2" {
  type = string
}

variable "sns_deliveries_failures_us_west_2" {
  type = string
}
