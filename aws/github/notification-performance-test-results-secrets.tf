# NOTE: We hard code the repository here because it's private and fails to resolve properly when used as a datasource.

resource "github_actions_secret" "perf_test_aws_access_key_id" {
  count           = var.env == "staging" ? 1 : 0
  repository      = "notification-performance-test-results"
  secret_name     = "${upper(var.env)}_AWS_ACCESS_KEY_ID"
  plaintext_value = var.aws_access_key_id
}

resource "github_actions_secret" "perf_test_aws_secret_access_key" {
  count           = var.env == "staging" ? 1 : 0
  repository      = "notification-performance-test-results"
  secret_name     = "${upper(var.env)}_AWS_SECRET_ACCESS_KEY"
  plaintext_value = var.aws_secret_access_key
}

resource "github_actions_secret" "perf_test_slack_webhook" {
  count           = var.env == "staging" ? 1 : 0
  repository      = "notification-performance-test-results"
  secret_name     = "SLACK_WEBHOOK"
  plaintext_value = var.notify_dev_slack_webhook
}