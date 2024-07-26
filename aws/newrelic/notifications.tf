resource "newrelic_notification_destination" "terraform_notify_destination" {
  count = var.enable_new_relic && var.env == "staging" ? 1 : 0

  account_id = var.new_relic_account_id
  active     = true
  name       = "Notify Slack Destination - ${var.env}"
  type       = "SLACK_LEGACY"
  property {
    display_value = var.env == "production" ? "notification-ops" : "notification-staging-ops"
    key           = "url"
    value         = var.new_relic_slack_webhook_url
  }
}

resource "newrelic_notification_channel" "terraform_notify_channel" {
  count = var.enable_new_relic && var.env == "staging" ? 1 : 0

  name           = "Notify Slack Channel - ${var.env}"
  type           = "SLACK_LEGACY"
  destination_id = newrelic_notification_destination.terraform_notify_destination[0].id
  product        = "IINT"

  property {
    key   = "payload"
    value = "{}"
    label = "Payload Template"
  }
}

resource "newrelic_workflow" "terraform_notify_workflow" {
  count = var.enable_new_relic && var.env == "staging" ? 1 : 0

  name                  = "Notify Workflow - ${var.env}"
  account_id            = var.new_relic_account_id
  enabled               = true
  enrichments_enabled   = true
  muting_rules_handling = "DONT_NOTIFY_FULLY_MUTED_ISSUES"


  destination {
    channel_id = newrelic_notification_channel.terraform_notify_channel[0].id
    notification_triggers = [
      "ACKNOWLEDGED",
      "ACTIVATED",
      "CLOSED"
    ]
  }

  issues_filter {
    name = "workflow-filter"
    type = "FILTER"

    predicate {
      attribute = "labels.policyIds"
      operator  = "EXACTLY_MATCHES"
      values = [
        newrelic_alert_policy.terraform_notify_policy[0].id
      ]
    }
    predicate {
      attribute = "priority"
      operator  = "EQUAL"
      values = [
        "CRITICAL",
      ]
    }
  }
}

