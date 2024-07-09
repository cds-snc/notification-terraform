resource "newrelic_notification_destination" "terraform_notify_slack_destination_staging" {
  account_id = var.new_relic_account_id
  active     = true
  name       = "Terraform Notify Slack Destination - Staging"
  type = "SLACK_LEGACY"
  property {
    display_value = "notification-staging-ops"
    key           = "url"
    value         = var.new_relic_slack_webhook_url
  }
}


resource "newrelic_notification_channel" "terraform_notify_slack_channel_staging" {
  name = "Terraform Notify Slack Channel - Staging"
  type = "SLACK_LEGACY"
  destination_id = newrelic_notification_destination.terraform_notify_slack_destination_staging.id
  product = "IINT"

  property {
    key = "payload"
    value = "{}"
    label = "Payload Template"
  }
}

resource "newrelic_workflow" "terraform_notify_workflow_staging" {
  name                = "Terraform Notify Workflow - Staging"
  account_id          = var.new_relic_account_id
  enabled             = true
  enrichments_enabled = true
  muting_rules_handling = "DONT_NOTIFY_FULLY_MUTED_ISSUES"


  destination {
    channel_id = newrelic_notification_channel.terraform_notify_slack_channel_staging.id
    notification_triggers = []
  }

  issues_filter {
    name = "workflow-filter"
    type = "FILTER"

    predicate {
      attribute = "labels.policyIds"
      operator  = "EXACTLY_MATCHES"
      values = [
        newrelic_alert_policy.terraform_notify_policy_staging.id
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

