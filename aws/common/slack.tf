# SNS to SRE Bot - Direct HTTPS subscriptions
# This replaces the legacy Lambda-based Slack integration with direct SNS→HTTPS to the SRE bot

resource "aws_sns_topic_subscription" "alert_warning_to_sre_bot" {
  topic_arn            = aws_sns_topic.notification-canada-ca-alert-warning.arn
  protocol             = "https"
  endpoint             = var.cloudwatch_slack_webhook_warning_topic
  raw_message_delivery = false
}

resource "aws_sns_topic_subscription" "alert_ok_to_sre_bot" {
  topic_arn            = aws_sns_topic.notification-canada-ca-alert-ok.arn
  protocol             = "https"
  endpoint             = var.cloudwatch_slack_webhook_general_topic
  raw_message_delivery = false
}

resource "aws_sns_topic_subscription" "alert_critical_to_sre_bot" {
  topic_arn            = aws_sns_topic.notification-canada-ca-alert-critical.arn
  protocol             = "https"
  endpoint             = var.cloudwatch_slack_webhook_critical_topic
  raw_message_delivery = false
}

resource "aws_sns_topic_subscription" "alert_general_to_sre_bot" {
  topic_arn            = aws_sns_topic.notification-canada-ca-alert-general.arn
  protocol             = "https"
  endpoint             = var.cloudwatch_slack_webhook_general_topic
  raw_message_delivery = false
}
