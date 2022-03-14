resource "aws_secretsmanager_secret" "app_environment_variables" {
  name = "environment_variables"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = aws_secretsmanager_secret.app_environment_variables.id
}
