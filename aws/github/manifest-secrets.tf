resource "github_actions_secret" "manifests_account_id" {
  repository       = data.github_repository.notification_manifests.name
  secret_name      = "${upper(var.env)}_AWS_ACCOUNT_ID"
  plaintext_value  = var.account_id
  destroy_on_drift = false
}

resource "github_actions_secret" "manifests_openai_api_key" {
  count            = var.env == "production" ? 1 : 0
  repository       = data.github_repository.notification_manifests.name
  secret_name      = "OPENAI_API_KEY"
  plaintext_value  = var.openai_api_key
  destroy_on_drift = false
}

resource "github_actions_secret" "manifests_op_service_account_token" {
  count            = var.env == "production" || var.env == "staging" || var.env == "dev" ? 1 : 0
  repository       = data.github_repository.notification_manifests.name
  secret_name      = "OP_SERVICE_ACCOUNT_TOKEN_${upper(var.env)}"
  plaintext_value  = var.op_service_account_token
  destroy_on_drift = false
}

resource "github_actions_secret" "manifests_aws_access_key_id" {
  count            = var.env == "production" || var.env == "staging" || var.env == "dev" ? 1 : 0
  repository       = data.github_repository.notification_manifests.name
  secret_name      = "${upper(var.env)}_AWS_ACCESS_KEY_ID"
  plaintext_value  = var.aws_access_key_id
  destroy_on_drift = false
}

resource "github_actions_secret" "manifests_aws_secret_access_key" {
  count            = var.env == "production" || var.env == "staging" || var.env == "dev" ? 1 : 0
  repository       = data.github_repository.notification_manifests.name
  secret_name      = "${upper(var.env)}_AWS_SECRET_ACCESS_KEY"
  plaintext_value  = var.aws_secret_access_key
  destroy_on_drift = false
}

resource "github_actions_secret" "manifests_notify_dev_slack_webhook" {
  count            = var.env == "production" ? 1 : 0
  repository       = data.github_repository.notification_manifests.name
  secret_name      = "SLACK_WEBHOOK"
  plaintext_value  = var.notify_dev_slack_webhook
  destroy_on_drift = false
}

resource "github_actions_secret" "manifests_cache_clear_client_secret" {
  count            = var.env == "production" || var.env == "staging" || var.env == "dev" ? 1 : 0
  repository       = data.github_repository.notification_manifests.name
  secret_name      = "${upper(var.env)}_CACHE_CLEAR_CLIENT_SECRET"
  plaintext_value  = var.manifest_cache_clear_client_secret
  destroy_on_drift = false
}

resource "github_actions_secret" "manifests_new_relic_api_key" {
  count            = var.env == "production" ? 1 : 0
  repository       = data.github_repository.notification_manifests.name
  secret_name      = "${upper(var.env)}_NEW_RELIC_API_KEY"
  plaintext_value  = var.new_relic_api_key
  destroy_on_drift = false
}

resource "github_actions_secret" "smoke_admin_client_secret" {
  count            = var.env == "production" || var.env == "staging" ? 1 : 0
  repository       = data.github_repository.notification_manifests.name
  secret_name      = "${upper(var.env)}_SMOKE_ADMIN_CLIENT_SECRET"
  plaintext_value  = var.manifest_smoke_admin_client_secret
  destroy_on_drift = false
}

resource "github_actions_secret" "smoke_api_key" {
  count            = var.env == "production" || var.env == "staging" ? 1 : 0
  repository       = data.github_repository.notification_manifests.name
  secret_name      = "${upper(var.env)}_SMOKE_API_KEY"
  plaintext_value  = var.manifest_smoke_api_key
  destroy_on_drift = false
}

resource "github_actions_secret" "pr_bot_github_token" {
  count            = var.env == "staging" ? 1 : 0
  repository       = data.github_repository.notification_manifests.name
  secret_name      = "PR_BOT_GITHUB_TOKEN"
  plaintext_value  = var.manifest_pr_bot_github_token
  destroy_on_drift = false
}
