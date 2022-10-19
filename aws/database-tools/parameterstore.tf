################################################################################
# Secrets - Database tools DB
################################################################################

resource "aws_secretsmanager_secret" "dbtools_database_user" {
  name        = "postgres"
  description = "Database superuser postgres, database connection values"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_secretsmanager_secret_version" "dbtools_database_user" {
  secret_id = aws_secretsmanager_secret.dbtools_database_user.id
  secret_string = jsonencode({
    username = "postgres"
    password = var.dbtools_password
  })
}

resource "aws_ssm_parameter" "db_tools_environment_variables" {
  name  = "BLAZER_DATABASE_URL"
  type  = "SecureString"
  value = "postgres://postgres:${var.dbtools_password}@${aws_db_instance.database-tools.address}:5432"
}



