# Doc: https://registry.terraform.io/modules/terraform-aws-modules/notify-slack/aws/
module "notify_slack_warning" {
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "~> 4.0"

  create_sns_topic = false
  sns_topic_name   = aws_sns_topic.notification-canada-ca-alert-warning.name

  slack_webhook_url = var.cloudwatch_slack_webhook_warning_topic
  slack_channel     = var.slack_channel_warning_topic
  slack_username    = "[WARNING] AWS Cloudwatch"
  slack_emoji       = ":aws:"

  lambda_function_name                   = "notify-slack-warning"
  cloudwatch_log_group_retention_in_days = 90
}

module "notify_slack_critical" {
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "~> 4.0"

  create_sns_topic = false
  sns_topic_name   = aws_sns_topic.notification-canada-ca-alert-critical.name

  slack_webhook_url = var.cloudwatch_slack_webhook_critical_topic
  slack_channel     = var.slack_channel_critical_topic
  slack_username    = "[CRITICAL] AWS Cloudwatch"
  slack_emoji       = ":aws:"

  lambda_function_name                   = "notify-slack-critical"
  cloudwatch_log_group_retention_in_days = 90
}
