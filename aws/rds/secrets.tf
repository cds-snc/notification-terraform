resource "aws_secretsmanager_secret" "sql_alchemy_database_uri" {
  name = "SQLALCHEMY_DATABASE_URI"
}

resource "aws_secretsmanager_secret_version" "sql_alchemy_database_uri" {
  secret_id     = aws_secretsmanager_secret.sql_alchemy_database_uri.id
  secret_string = "postgresql://${var.app_db_user}:${var.app_db_user_password}@${module.rds_proxy.proxy_endpoint}:${module.rds_proxy.proxy_target_port}/${var.rds_database_name}"
}
