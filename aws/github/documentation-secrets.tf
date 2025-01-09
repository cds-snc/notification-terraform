resource "github_actions_secret" "documentation_op_service_account_token" {
  count           = var.env == "production" || var.env == "staging" ? 1 : 0
  repository      = data.github_repository.notification_documentation.name
  secret_name     = "OP_SERVICE_ACCOUNT_TOKEN_${upper(var.env)}"
  plaintext_value = var.op_service_account_token
}

resource "github_actions_secret" "documentation_api_github_manifests_workflow_token" {
  count           = var.env == "staging" ? 1 : 0
  repository      = data.github_repository.notification_documentation.name
  secret_name     = "MANIFESTS_WORKFLOW_TOKEN"
  plaintext_value = var.github_manifests_workflow_token
}
