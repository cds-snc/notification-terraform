variable "cloudwatch_opsgenie_alarm_webhook" {
  type = string
}

variable "cloudwatch_slack_webhook_critical_topic" {
  type = string
}

variable "cloudwatch_slack_webhook_warning_topic" {
  type = string
}

variable "elasticache_node_type" {
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

variable "vpc_private_subnets" {
  type = list(any)
}
