resource "github_actions_secret" "system_status_static_aws_access_key_id" {
  count            = var.env == "production" || var.env == "staging" ? 1 : 0
  repository       = data.github_repository.notification_system_status_frontend.name
  secret_name      = "${upper(var.env)}_AWS_ACCESS_KEY_ID"
  plaintext_value  = var.aws_access_key_id
  destroy_on_drift = false
}

resource "github_actions_secret" "system_status_static_aws_secret_access_key" {
  count            = var.env == "production" || var.env == "staging" ? 1 : 0
  repository       = data.github_repository.notification_system_status_frontend.name
  secret_name      = "${upper(var.env)}_AWS_SECRET_ACCESS_KEY"
  plaintext_value  = var.aws_secret_access_key
  destroy_on_drift = false
}

resource "github_actions_secret" "system_status_bucket" {
  count            = var.env == "production" || var.env == "staging" ? 1 : 0
  repository       = data.github_repository.notification_system_status_frontend.name
  secret_name      = "${upper(var.env)}_SYSTEM_STATUS_BUCKET"
  plaintext_value  = "notification-canada-ca-${var.env}-system-status"
  destroy_on_drift = false
}

resource "github_actions_secret" "system_status_cloudfront_distribution" {
  count            = var.env == "production" || var.env == "staging" ? 1 : 0
  repository       = data.github_repository.notification_system_status_frontend.name
  secret_name      = "${upper(var.env)}_SYSTEM_STATUS_CLOUDFRONT_DISTRIBUTION"
  plaintext_value  = var.system_status_static_site_cloudfront_distribution
  destroy_on_drift = false
}

resource "github_actions_secret" "slack_notify_dev_webhook" {
  count            = var.env == "production" ? 1 : 0
  repository       = data.github_repository.notification_system_status_frontend.name
  secret_name      = "SLACK_NOTIFY_DEV_WEBHOOK"
  plaintext_value  = var.notify_dev_slack_webhook
  destroy_on_drift = false
}

resource "github_actions_secret" "system_status_account_id" {
  repository       = data.github_repository.notification_system_status_frontend.name
  secret_name      = "${upper(var.env)}_AWS_ACCOUNT_ID"
  plaintext_value  = var.account_id
  destroy_on_drift = false
}
