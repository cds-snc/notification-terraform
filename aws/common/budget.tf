
resource "aws_budgets_budget" "notify_global" {
  name         = "notify-global-budget"
  budget_type  = "COST"
  limit_amount = var.account_budget_limit
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 100
    threshold_type            = "PERCENTAGE"
    notification_type         = "FORECASTED"
    subscriber_sns_topic_arns = [aws_sns_topic.notification-canada-ca-alert-general.arn]
  }

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 80
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_sns_topic_arns = [aws_sns_topic.notification-canada-ca-alert-general.arn]
  }
}

module "spend_notifier" {
  source                     = "github.com/cds-snc/terraform-modules//spend_notifier?ref=main"
  daily_spend_notifier_hook  = "d5bfc2dc-07d9-4553-adbb-08a0b44a4bea"
  weekly_spend_notifier_hook = "d5bfc2dc-07d9-4553-adbb-08a0b44a4bea"
  billing_tag_value          = "notification-canada-ca-${var.env}"
  account_name               = "Notification-${var.env}"
}
