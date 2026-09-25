# Blazer's ECS task has no direct internet egress, so check notifications are
# published to SNS and delivered to the Slack webhook by SNS itself instead of
# the blazer container calling hooks.slack.com directly.
resource "aws_sns_topic" "blazer_check_alerts" {
  provider = aws.core_services
  name     = "blazer-check-alerts"

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
    Terraform             = true
  }
}

resource "aws_sns_topic_subscription" "blazer_check_alerts_to_slack" {
  provider  = aws.core_services
  topic_arn = aws_sns_topic.blazer_check_alerts.arn
  protocol  = "https"
  endpoint  = var.blazer_slack_webhook_general_topic

  # deliver the raw Slack payload blazer builds, without SNS's envelope
  raw_message_delivery = true
}
