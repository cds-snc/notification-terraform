resource "github_actions_secret" "dd_op_service_account_token" {
  count           = var.env == "production" || var.env == "staging" ? 1 : 0
  repository      = data.github_repository.notification_document_download.name
  secret_name     = "OP_SERVICE_ACCOUNT_TOKEN_${upper(var.env)}"
  plaintext_value = var.op_service_account_token
}

resource "github_actions_secret" "dd_slack_webhook" {
  count           = var.env == "production" ? 1 : 0
  repository      = data.github_repository.notification_document_download.name
  secret_name     = "SLACK_WEBHOOK"
  plaintext_value = var.notify_dev_slack_webhook
}
