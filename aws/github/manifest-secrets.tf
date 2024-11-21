resource "github_actions_secret" "manifests_account_id" {
  repository      = data.github_repository.notification_manifests.name
  secret_name     = "${upper(var.env)}_ACCOUNT_ID"
  plaintext_value = var.account_id
}

resource "github_actions_secret" "manifests_openai_api_key" {
  count           = var.env == "production" ? 1 : 0
  repository      = data.github_repository.notification_manifests.name
  secret_name     = "OPENAI_API_KEY"
  plaintext_value = var.openai_api_key
}

resource "github_actions_secret" "manifests_op_service_account_token" {
  count           = var.env == "production" || var.env == "staging" ? 1 : 0
  repository      = data.github_repository.notification_manifests.name
  secret_name     = "OP_SERVICE_ACCOUNT_TOKEN_${upper(var.env)}"
  plaintext_value = var.op_service_account_token
}

resource "github_actions_secret" "manifests_production_api_url" {
  count           = var.env == "production" ? 1 : 0
  repository      = data.github_repository.notification_manifests.name
  secret_name     = "PRODUCTION_API_URL"
  plaintext_value = var.op_service_account_token
}

resource "github_actions_secret" "manifests_aws_access_key_id" {
  count           = var.env == "production" || var.env == "staging" ? 1 : 0
  repository      = data.github_repository.notification_manifests.name
  secret_name     = "${upper(var.env)}_AWS_ACCESS_KEY_ID"
  plaintext_value = var.aws_access_key_id
}

resource "github_actions_secret" "manifests_aws_secret_access_key" {
  count           = var.env == "production" || var.env == "staging" ? 1 : 0
  repository      = data.github_repository.notification_manifests.name
  secret_name     = "${upper(var.env)}_AWS_SECRET_ACCESS_KEY"
  plaintext_value = var.aws_secret_access_key
}

resource "github_actions_secret" "manifests_notify_dev_slack_webhook" {
  count           = var.env == "production" ? 1 : 0
  repository      = data.github_repository.notification_manifests.name
  secret_name     = "SLACK_WEBHOOK"
  plaintext_value = var.notify_dev_slack_webhook
}

resource "github_actions_secret" "manifests_cache_clear_client_secret" {
  count           = var.env == "production" || var.env == "staging" ? 1 : 0
  repository      = data.github_repository.notification_manifests.name
  secret_name     = "${upper(var.env)}_CACHE_CLEAR_CLIENT_SECRET"
  plaintext_value = var.cache_clear_client_secret
}

resource "github_actions_secret" "manifests_cache_clear_user_name" {
  count           = var.env == "production" || var.env == "staging" ? 1 : 0
  repository      = data.github_repository.notification_manifests.name
  secret_name     = "${upper(var.env)}_CACHE_CLEAR_USER_NAME"
  plaintext_value = var.cache_clear_user_name
}

resource "github_actions_secret" "manifests_new_relic_api_key" {
  count           = var.env == "production" ? 1 : 0
  repository      = data.github_repository.notification_manifests.name
  secret_name     = "${upper(var.env)}_NEW_RELIC_API_KEY"
  plaintext_value = var.new_relic_api_key
}
