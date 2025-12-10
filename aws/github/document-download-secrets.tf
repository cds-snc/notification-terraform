resource "github_actions_secret" "dd_op_service_account_token" {
  count            = var.env == "production" || var.env == "staging" ? 1 : 0
  repository       = data.github_repository.notification_document_download.name
  secret_name      = "OP_SERVICE_ACCOUNT_TOKEN_${upper(var.env)}"
  plaintext_value  = var.op_service_account_token
  destroy_on_drift = false
}

resource "github_actions_secret" "dd_slack_webhook" {
  count            = var.env == "production" ? 1 : 0
  repository       = data.github_repository.notification_document_download.name
  secret_name      = "SLACK_WEBHOOK"
  plaintext_value  = var.notify_dev_slack_webhook
  destroy_on_drift = false
}

resource "github_actions_secret" "dd_github_manifests_workflow_token" {
  count            = var.env == "staging" ? 1 : 0
  repository       = data.github_repository.notification_document_download.name
  secret_name      = "MANIFESTS_WORKFLOW_TOKEN"
  plaintext_value  = var.github_manifests_workflow_token
  destroy_on_drift = false
}

resource "github_actions_secret" "document_download_account_id" {
  repository       = data.github_repository.notification_document_download.name
  secret_name      = "${upper(var.env)}_AWS_ACCOUNT_ID"
  plaintext_value  = var.account_id
  destroy_on_drift = false
}
