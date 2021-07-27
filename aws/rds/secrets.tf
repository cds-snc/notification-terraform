
resource "aws_secretsmanager_secret" "server_database_url" {
  name = "server-database-url-${random_string.random.result}"
}

resource "aws_secretsmanager_secret_version" "server_database_url" {
  secret_id     = aws_secretsmanager_secret.server_database_url.id
  secret_string = "${var.rds_server_db_user}:${var.rds_cluster_password}@tcp(${aws_rds_cluster.covidshield_server.endpoint})/${var.rds_server_db_name}"
}
