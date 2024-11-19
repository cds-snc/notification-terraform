resource "github_actions_secret" "test" {
  repository      = data.github_repository.notification_terraform.name
  secret_name     = "bentest"
  plaintext_value = "testing"
}