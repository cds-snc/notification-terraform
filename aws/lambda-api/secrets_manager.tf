resource "aws_secretsmanager_secret" "ecr-user-access-key" {
  name = "ecr-user-access-key"
}

resource "aws_secretsmanager_secret_version" "ecr-user-access-key" {
  secret_id     = aws_secretsmanager_secret.ecr-user-access-key.id
  secret_string = aws_iam_access_key.ecr-user.secret
}

# Created outside terraform when New Relic was integrated
data "aws_secretsmanager_secret" "new-relic-license-key-secret" {
  name = "NEW_RELIC_LICENSE_KEY"
}

data "aws_secretsmanager_secret_version" "new-relic-license-key" {
  secret_id = data.aws_secretsmanager_secret.new-relic-license-key.id
}
