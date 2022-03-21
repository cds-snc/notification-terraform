resource "aws_secretsmanager_secret" "environment_variables" {
  name = "environment_variables"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}
