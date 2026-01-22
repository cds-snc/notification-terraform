# SNS to SRE Bot - Direct HTTPS subscriptions (new approach for dev/staging)
# Only created when NOT in production

resource "aws_sns_topic_subscription" "alert_warning_to_sre_bot" {
  count                = var.env == "production" ? 0 : 1
  topic_arn            = aws_sns_topic.notification-canada-ca-alert-warning.arn
  protocol             = "https"
  endpoint             = var.cloudwatch_slack_webhook_warning_topic
  raw_message_delivery = false
}

resource "aws_sns_topic_subscription" "alert_ok_to_sre_bot" {
  count                = var.env == "production" ? 0 : 1
  topic_arn            = aws_sns_topic.notification-canada-ca-alert-ok.arn
  protocol             = "https"
  endpoint             = var.cloudwatch_slack_webhook_general_topic
  raw_message_delivery = false
}

resource "aws_sns_topic_subscription" "alert_critical_to_sre_bot" {
  count                = var.env == "production" ? 0 : 1
  topic_arn            = aws_sns_topic.notification-canada-ca-alert-critical.arn
  protocol             = "https"
  endpoint             = var.cloudwatch_slack_webhook_critical_topic
  raw_message_delivery = false
}

resource "aws_sns_topic_subscription" "alert_general_to_sre_bot" {
  count                = var.env == "production" ? 0 : 1
  topic_arn            = aws_sns_topic.notification-canada-ca-alert-general.arn
  protocol             = "https"
  endpoint             = var.cloudwatch_slack_webhook_general_topic
  raw_message_delivery = false
}

# Legacy Lambda-based Slack integration (for production only)
# Only created when in production

module "notify_slack_warning" {
  count   = var.env == "production" ? 1 : 0
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "~> 6.5.1"

  sns_topic_name    = aws_sns_topic.notification-canada-ca-alert-warning.name
  slack_webhook_url = var.slack_channel_warning_topic
  slack_channel     = "notification-ops"
  slack_username    = "AWS"
}

module "notify_slack_ok" {
  count   = var.env == "production" ? 1 : 0
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "~> 6.5.1"

  sns_topic_name    = aws_sns_topic.notification-canada-ca-alert-ok.name
  slack_webhook_url = var.slack_channel_warning_topic
  slack_channel     = "notification-ops"
  slack_username    = "AWS"
}

module "notify_slack_critical" {
  count   = var.env == "production" ? 1 : 0
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "~> 6.5.1"

  sns_topic_name    = aws_sns_topic.notification-canada-ca-alert-critical.name
  slack_webhook_url = var.slack_channel_critical_topic
  slack_channel     = "notification-ops"
  slack_username    = "AWS"
}

module "notify_slack_general" {
  count   = var.env == "production" ? 1 : 0
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "~> 6.5.1"

  sns_topic_name    = aws_sns_topic.notification-canada-ca-alert-general.name
  slack_webhook_url = var.slack_channel_general_topic
  slack_channel     = "notification-ops"
  slack_username    = "AWS"
}
