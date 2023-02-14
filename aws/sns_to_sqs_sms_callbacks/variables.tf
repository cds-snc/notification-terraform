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

variable "sns_alert_ok_arn" {
  type = string
}

variable "sns_deliveries_ca_central_arn" {
  type = string
}

variable "sns_deliveries_ca_central_name" {
  type = string
}

variable "sns_deliveries_failures_ca_central_arn" {
  type = string
}

variable "sns_deliveries_failures_ca_central_name" {
  type = string
}

variable "sns_deliveries_us_west_2_arn" {
  type = string
}

variable "sns_deliveries_us_west_2_name" {
  type = string
}

variable "sns_deliveries_failures_us_west_2_arn" {
  type = string
}

variable "sns_deliveries_failures_us_west_2_name" {
  type = string
}
