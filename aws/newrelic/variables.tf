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