resource "aws_secretsmanager_secret" "ecr-user-access-key" {
  name = "ecr-user-access-key"
}

resource "aws_secretsmanager_secret_version" "ecr-user-access-key" {
  secret_id     = aws_secretsmanager_secret.ecr-user-access-key.id
  secret_string = aws_iam_access_key.ecr-user.secret
}
