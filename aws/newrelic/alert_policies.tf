resource "newrelic_alert_policy" "terraform_notify_policy" {
  name     = "Notify Policy - ${var.env}"
  provider = newrelic
}

