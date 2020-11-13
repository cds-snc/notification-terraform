# Doc: https://registry.terraform.io/modules/terraform-aws-modules/notify-slack/aws/
module "notify_slack" {
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "~> 4.0"

  sns_topic_name = "cloudwatch-slack-topic"

  slack_webhook_url = var.cloudwatch_slack_webhook
  slack_channel     = "notification-ops"
  slack_username    = "AWS Cloudwatch"
  slack_emoji       = ":lightning:"
}
