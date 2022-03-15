resource "aws_secretsmanager_secret" "environment_variables" {
  name = "environment_variables"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

data "aws_secretsmanager_secret_version" "environment_variables_current" {
  secret_id = aws_secretsmanager_secret.environment_variables.id
}
