resource "newrelic_alert_policy" "terraform_notify_policy" {
  name     = "TF Notify Policy - ${var.env}"
  provider = newrelic
}

