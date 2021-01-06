variable "cloudwatch_opsgenie_alarm_webhook" {
  type = string
}

variable "cloudwatch_slack_webhook_critical_topic" {
  type = string
}

variable "cloudwatch_slack_webhook_warning_topic" {
  type = string
}

variable "slack_channel_critical_topic" {
  type = string
}

variable "slack_channel_warning_topic" {
  type = string
}

variable "sns_monthly_spend_limit" {
  type = number
}

variable "sns_monthly_spend_limit_us_west_2" {
  type = number
}