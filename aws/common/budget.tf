
resource "aws_budgets_budget" "notify_global" {
  name         = "notify-global-budget"
  budget_type  = "COST"
  limit_amount = var.account_budget_limit
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 1
    threshold_type            = "PERCENTAGE"
    notification_type         = "FORECASTED"
    subscriber_sns_topic_arns = [aws_sns_topic.notification-canada-ca-alert-general.arn]
  }

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 1
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_sns_topic_arns = [aws_sns_topic.notification-canada-ca-alert-general.arn]
  }
}

resource "aws_budgets_budget" "cloudwatch_data_scanned" {
  name         = "cloudwatch-data-scanned-budget"
  budget_type  = "USAGE"
  limit_amount = "10000"
  limit_unit   = "GB"
  time_unit    = "DAILY"

  cost_filter {
    name = "UsageType"
    values = [
      "CAN1-DataScanned-Bytes",
    ]
  }

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 100
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
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

module "budget_notifier" {
  source                     = "github.com/cds-snc/terraform-modules//spend_notifier?ref=v9.6.4"
  daily_spend_notifier_hook  = var.budget_sre_bot_webhook
  weekly_spend_notifier_hook = var.budget_sre_bot_webhook
  billing_tag_value          = "notification-canada-ca-${var.env}"
  account_name               = "Notification-${var.env}"
}
