locals {
  db_user     = "postgres"
  app_db_user = "app_db_user"
}

################################################################################
# Secrets - DB user passwords
################################################################################

resource "random_string" "app_db_user" {
  count   = var.env == "production" || var.env == "staging" ? 0 : 1
  length  = 8
  special = false
}

resource "random_string" "db_user" {
  count   = var.env == "production" || var.env == "staging" ? 0 : 1
  length  = 8
  special = false
}

resource "aws_secretsmanager_secret" "database_user" {
  name        = var.env == "production" || var.env == "staging" ? local.db_user : "${local.db_user}_${random_string.db_user[0].result}"
  description = "Database superuser ${local.db_user}, database connection values"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_secretsmanager_secret_version" "database_user" {
  secret_id = aws_secretsmanager_secret.database_user.id
  secret_string = jsonencode({
    username = local.db_user
    password = var.rds_cluster_password
  })
}

resource "aws_secretsmanager_secret" "app_db_user" {
  name        = var.env == "production" || var.env == "staging" ? local.app_db_user : "${local.app_db_user}_${random_string.app_db_user[0].result}"
  description = "Database superuser ${local.app_db_user}, database connection values"
  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_secretsmanager_secret_version" "app_db_user" {
  secret_id = aws_secretsmanager_secret.app_db_user.id
  secret_string = jsonencode({
    username = local.app_db_user
    password = var.app_db_user_password
  })
}
