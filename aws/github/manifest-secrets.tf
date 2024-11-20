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
