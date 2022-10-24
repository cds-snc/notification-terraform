################################################################################
# Secrets - Database tools DB
################################################################################

resource "aws_ssm_parameter" "db_tools_environment_variables" {
  name  = "DATABASE_TOOLS_URL"
  type  = "SecureString"
  value = "postgres://postgres:${var.dbtools_password}@${aws_db_instance.database-tools.address}:5432"

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
    Terraform             = true
  }
}

resource "aws_ssm_parameter" "sqlalchemy_database_reader_uri" {
  name  = "NOTIFICATION_DB_READ_URL"
  type  = "SecureString"
  value = var.sqlalchemy_database_reader_uri

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
    Terraform             = true
  }
}

