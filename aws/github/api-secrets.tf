resource "github_actions_secret" "api_account_id" {
  repository       = data.github_repository.notification_api.name
  secret_name      = "${upper(var.env)}_AWS_ACCOUNT_ID"
  plaintext_value  = var.account_id
  destroy_on_drift = false
}

resource "github_actions_secret" "api_aws_access_key_id" {
  count            = var.env == "production" || var.env == "staging" ? 1 : 0
  repository       = data.github_repository.notification_api.name
  secret_name      = "${upper(var.env)}_AWS_ACCESS_KEY_ID"
  plaintext_value  = var.aws_access_key_id
  destroy_on_drift = false
}

resource "github_actions_secret" "api_aws_secret_access_key" {
  count            = var.env == "production" || var.env == "staging" ? 1 : 0
  repository       = data.github_repository.notification_api.name
  secret_name      = "${upper(var.env)}_AWS_SECRET_ACCESS_KEY"
  plaintext_value  = var.aws_secret_access_key
  destroy_on_drift = false
}

resource "github_actions_secret" "api_cypress_user_pw_secret" {
  count            = var.env == "staging" ? 1 : 0
  repository       = data.github_repository.notification_api.name
  secret_name      = "CYPRESS_USER_PW_SECRET"
  plaintext_value  = var.manifest_cypress_user_pw_secret
  destroy_on_drift = false
}

resource "github_actions_secret" "api_openai_api_key" {
  count            = var.env == "production" ? 1 : 0
  repository       = data.github_repository.notification_api.name
  secret_name      = "OPENAI_API_KEY"
  plaintext_value  = var.openai_api_key
  destroy_on_drift = false
}

resource "github_actions_secret" "api_op_service_account_token" {
  count            = var.env == "production" || var.env == "staging" ? 1 : 0
  repository       = data.github_repository.notification_api.name
  secret_name      = "OP_SERVICE_ACCOUNT_TOKEN_${upper(var.env)}"
  plaintext_value  = var.op_service_account_token
  destroy_on_drift = false
}

resource "github_actions_secret" "api_slack_webhook" {
  count            = var.env == "production" ? 1 : 0
  repository       = data.github_repository.notification_api.name
  secret_name      = "SLACK_WEBHOOK"
  plaintext_value  = var.notify_dev_slack_webhook
  destroy_on_drift = false
}

resource "github_actions_secret" "api_github_manifests_workflow_token" {
  count            = var.env == "staging" ? 1 : 0
  repository       = data.github_repository.notification_api.name
  secret_name      = "MANIFESTS_WORKFLOW_TOKEN"
  plaintext_value  = var.github_manifests_workflow_token
  destroy_on_drift = false
}
