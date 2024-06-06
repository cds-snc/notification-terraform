resource "random_string" "new_relic_postfix" {
  count = var.env == "production" || var.env == "staging" ? 0 : 1

  length  = 8
  special = false
}

resource "aws_secretsmanager_secret" "new-relic-license-key" {
  name                    = var.env == "production" || var.env == "staging" ? "NEW_RELIC_LICENSE_KEY" : "NEW_RELIC_LICENSE_KEY_${random_string.new_relic_postfix[0].result}"
  description             = "The New Relic license key, for sending telemetry"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "new-relic-license-key" {
  secret_id     = aws_secretsmanager_secret.new-relic-license-key.id
  secret_string = var.new_relic_license_key
}
