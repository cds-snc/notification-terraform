resource "aws_secretsmanager_secret" "ecr-user-access-key" {
  name = "ecr-user-access-key"
}

resource "aws_secretsmanager_secret_version" "ecr-user-access-key" {
  secret_id     = aws_secretsmanager_secret.ecr-user-access-key.id
  secret_string = aws_iam_access_key.ecr-user.secret
}

resource "aws_secretsmanager_secret" "new-relic-license-key" {
  name        = "NEW_RELIC_LICENSE_KEY"
  description = "The New Relic license key, for sending telemetry"
}

resource "aws_secretsmanager_secret_version" "new-relic-license-key" {
  secret_id     = aws_secretsmanager_secret.new-relic-license-key.id
  secret_string = var.new_relic_license_key
}
