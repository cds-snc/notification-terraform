resource "github_actions_secret" "admin_a11y_tracker_key" {
  count            = var.env == "production" ? 1 : 0
  repository       = data.github_repository.notification_admin.name
  secret_name      = "A11Y_TRACKER_KEY"
  plaintext_value  = var.admin_a11y_tracker_key
  destroy_on_drift = false
}

resource "github_actions_secret" "admin_aws_access_key" {
  count            = var.env == "production" || var.env == "staging" ? 1 : 0
  repository       = data.github_repository.notification_admin.name
  secret_name      = "${upper(var.env)}_AWS_ACCESS_KEY_ID"
  plaintext_value  = var.aws_access_key_id
  destroy_on_drift = false
}

resource "github_actions_secret" "admin_aws_secret_access_key" {
  count            = var.env == "production" || var.env == "staging" ? 1 : 0
  repository       = data.github_repository.notification_admin.name
  secret_name      = "${upper(var.env)}_AWS_SECRET_ACCESS_KEY"
  plaintext_value  = var.aws_secret_access_key
  destroy_on_drift = false
}

resource "github_actions_secret" "admin_cypress_env_json" {
  count            = var.env == "staging" ? 1 : 0
  repository       = data.github_repository.notification_admin.name
  secret_name      = "CYPRESS_ENV_JSON"
  plaintext_value  = base64decode(var.admin_cypress_env_json)
  destroy_on_drift = false
}

resource "github_actions_secret" "admin_openai_api_key" {
  count            = var.env == "production" ? 1 : 0
  repository       = data.github_repository.notification_admin.name
  secret_name      = "OPENAI_API_KEY"
  plaintext_value  = var.openai_api_key
  destroy_on_drift = false
}

resource "github_actions_secret" "admin_op_service_account_token" {
  count            = var.env == "production" || var.env == "staging" ? 1 : 0
  repository       = data.github_repository.notification_admin.name
  secret_name      = "OP_SERVICE_ACCOUNT_TOKEN_${upper(var.env)}"
  plaintext_value  = var.op_service_account_token
  destroy_on_drift = false
}

resource "github_actions_secret" "admin_pr_review_env_security_group_ids" {
  count            = var.env == "staging" ? 1 : 0
  repository       = data.github_repository.notification_admin.name
  secret_name      = "PR_REVIEW_ENV_SECURITY_GROUP_IDS"
  plaintext_value  = var.admin_pr_review_env_security_group_ids
  destroy_on_drift = false
}

resource "github_actions_secret" "admin_pr_review_env_subnet_ids" {
  count            = var.env == "staging" ? 1 : 0
  repository       = data.github_repository.notification_admin.name
  secret_name      = "PR_REVIEW_ENV_SUBNET_IDS"
  plaintext_value  = var.admin_pr_review_env_subnet_ids
  destroy_on_drift = false
}

resource "github_actions_secret" "admin_slack_webhook" {
  count            = var.env == "production" ? 1 : 0
  repository       = data.github_repository.notification_admin.name
  secret_name      = "SLACK_WEBHOOK"
  plaintext_value  = var.notify_dev_slack_webhook
  destroy_on_drift = false
}

resource "github_actions_secret" "admin_github_manifests_workflow_token" {
  count            = var.env == "staging" ? 1 : 0
  repository       = data.github_repository.notification_admin.name
  secret_name      = "MANIFESTS_WORKFLOW_TOKEN"
  plaintext_value  = var.github_manifests_workflow_token
  destroy_on_drift = false
}

resource "github_actions_secret" "admin_account_id" {
  repository       = data.github_repository.notification_admin.name
  secret_name      = "${upper(var.env)}_AWS_ACCOUNT_ID"
  plaintext_value  = var.account_id
  destroy_on_drift = false
}
