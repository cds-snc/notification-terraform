resource "aws_secretsmanager_secret" "new-relic-license-key" {
  name                    = "NEW_RELIC_LICENSE_KEY"
  description             = "The New Relic license key, for sending telemetry"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "new-relic-license-key" {
  secret_id     = aws_secretsmanager_secret.new-relic-license-key.id
  secret_string = var.new_relic_license_key
}
