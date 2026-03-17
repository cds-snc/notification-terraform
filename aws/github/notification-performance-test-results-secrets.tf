# NOTE: We hard code the repository here because it's private and fails to resolve properly when used as a datasource.

resource "github_actions_secret" "perf_test_slack_webhook" {
  count            = var.env == "staging" ? 1 : 0
  repository       = "notification-performance-test-results"
  secret_name      = "SLACK_WEBHOOK"
  plaintext_value  = var.notify_dev_slack_webhook
  destroy_on_drift = false
}

resource "github_actions_secret" "perf_test_account_id" {
  count            = var.env == "staging" ? 1 : 0
  repository       = "notification-performance-test-results"
  secret_name      = "ACCOUNT_ID"
  plaintext_value  = var.account_id
  destroy_on_drift = false
}
