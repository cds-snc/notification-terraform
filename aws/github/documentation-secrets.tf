resource "github_actions_secret" "documentation_op_service_account_token" {
  count           = var.env == "production" || var.env == "staging" ? 1 : 0
  repository      = data.github_repository.notification_documentation.name
  secret_name     = "OP_SERVICE_ACCOUNT_TOKEN_${upper(var.env)}"
  plaintext_value = var.op_service_account_token
}
