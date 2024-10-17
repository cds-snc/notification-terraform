resource "aws_secretsmanager_secret" "sqlalachemy_database_uri" {
  name                    = "SQLALCHEMY_DATABASE_URI"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "sqlalachemy_database_uri" {
  secret_id     = aws_secretsmanager_secret.sqlalachemy_database_uri.id
  secret_string = "postgresql://${var.app_db_user}:${var.app_db_user_password}@${module.rds_proxy.db_proxy_endpoints.read_write.endpoint}:${module.rds_proxy.proxy_target_port}/${var.rds_database_name}"
}

resource "aws_secretsmanager_secret" "sqlalachemy_database_reader_uri" {
  name                    = "SQLALCHEMY_DATABASE_READER_URI"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "sqlalachemy_database_reader_uri" {
  secret_id     = aws_secretsmanager_secret.sqlalachemy_database_reader_uri.id
  secret_string = "postgresql://${var.app_db_user}:${var.app_db_user_password}@${module.rds_proxy.db_proxy_endpoints.read_only.endpoint}:${module.rds_proxy.proxy_target_port}/${var.rds_database_name}"
}

resource "aws_secretsmanager_secret" "postgres_host" {
  name                    = "POSTGRES_HOST"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "postgres_host" {
  secret_id     = aws_secretsmanager_secret.postgres_host.id
  secret_string = module.rds_proxy.db_proxy_endpoints.read_only.endpoint
}