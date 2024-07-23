resource "newrelic_notification_destination" "terraform_notify_destination" {
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
  name           = "Notify Slack Channel - ${var.env}"
  type           = "SLACK_LEGACY"
  destination_id = newrelic_notification_destination.terraform_notify_destination.id
  product        = "IINT"

  property {
    key   = "payload"
    value = "{}"
    label = "Payload Template"
  }
}

resource "newrelic_workflow" "terraform_notify_workflow" {
  name                  = "Notify Workflow - ${var.env}"
  account_id            = var.new_relic_account_id
  enabled               = true
  enrichments_enabled   = true
  muting_rules_handling = "DONT_NOTIFY_FULLY_MUTED_ISSUES"


  destination {
    channel_id            = newrelic_notification_channel.terraform_notify_channel.id
    name                  = "Terraform Notify Slack Channel - ${var.env}"
    notification_triggers = [
      "ACKNOWLEDGED",
      "ACTIVATED",
      "CLOSED"
    ]
    type                  = "SLACK_LEGACY" 
  }

  issues_filter {
    name = "workflow-filter"
    type = "FILTER"

    predicate {
      attribute = "labels.policyIds"
      operator  = "EXACTLY_MATCHES"
      values = [
        newrelic_alert_policy.terraform_notify_policy.id
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

