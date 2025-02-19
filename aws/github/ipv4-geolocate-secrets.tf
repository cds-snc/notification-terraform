resource "github_actions_secret" "ipv4_maxmind_license_key" {
  count           = var.env == "production" ? 1 : 0
  repository      = data.github_repository.ipv4_geolocate.name
  secret_name     = "MAXMIND_LICENSE_KEY"
  plaintext_value = var.ipv4_maxmind_license_key
}

resource "github_actions_secret" "ipv4_op_service_account_token" {
  count           = var.env == "production" || var.env == "staging" ? 1 : 0
  repository      = data.github_repository.ipv4_geolocate.name
  secret_name     = "${upper(var.env)}_OP_SERVICE_ACCOUNT_TOKEN"
  plaintext_value = var.op_service_account_token
}
