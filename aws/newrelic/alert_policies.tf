resource "newrelic_alert_policy" "terraform_notify_policy_staging" {
  name     = "Terraform Notify Policy - Staging"
  provider = newrelic
}

