# Doc: https://registry.terraform.io/modules/terraform-aws-modules/notify-slack/aws/
module "notify_slack_warning" {
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "~> 4.0"

  sns_topic_name = "cloudwatch-slack-topic-warning"

  slack_webhook_url = var.cloudwatch_slack_webhook_warning_topic
  slack_channel     = var.slack_channel_warning_topic
  slack_username    = "[WARNING] AWS Cloudwatch"
  slack_emoji       = ":aws:"
}

module "notify_slack_critical" {
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "~> 4.0"

  sns_topic_name = "cloudwatch-slack-topic-critical"

  slack_webhook_url = var.cloudwatch_slack_webhook_critical_topic
  slack_channel     = var.slack_channel_critical_topic
  slack_username    = "[CRITICAL] AWS Cloudwatch"
  slack_emoji       = ":aws:"
}
