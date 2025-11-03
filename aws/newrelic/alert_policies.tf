resource "newrelic_alert_policy" "terraform_notify_policy" {
  count = var.enable_new_relic ? 1 : 0

  name     = "Notify Policy - ${var.env}"
  provider = newrelic
}

resource "newrelic_alert_policy" "terraform_notify_policy_by_condition" {
  count = var.enable_new_relic ? 1 : 0

  name                = "Notify Policy - ${var.env} by condition"
  provider            = newrelic
  incident_preference = "PER_CONDITION"
}
