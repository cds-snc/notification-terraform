locals {
  db_user = "postgres"
}

################################################################################
# Secrets - DB user passwords
################################################################################

resource "aws_secretsmanager_secret" "dbtools_database_user" {
  name        = local.db_user
  description = "Database superuser ${local.db_user}, database connection values"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_secretsmanager_secret_version" "dbtools_database_user" {
  secret_id = aws_secretsmanager_secret.dbtools_database_user.id
  secret_string = jsonencode({
    username = local.db_user
    password = var.dbtools_password
  })

}
