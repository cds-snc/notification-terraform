locals {
  db_user = "postgres"
}

################################################################################
# Secrets - DB user passwords
################################################################################

resource "aws_secretsmanager_secret" "superuser" {
  name        = local.db_user
  description = "Database superuser ${local.db_username}, database connection values"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_secretsmanager_secret_version" "superuser" {
  secret_id = aws_secretsmanager_secret.superuser.id
  secret_string = jsonencode({
    username = local.db_user
    password = var.rds_cluster_password
  })

}

################################################################################
# RDS Proxy
################################################################################

module "rds_proxy" {
  source = "clowdhaus/rds-proxy/aws"
  version = "~> 2.0"

  name                    = "rds-proxy"
  iam_role_name           = "rds-proxy-to-secrets-role"
  iam_policy_name         = "rds-proxy-to-secrets-policy"

  idle_client_timeout     = 600
  max_connections_percent = 90
  require_tls             = false

  vpc_subnet_ids          = var.vpc_private_subnets
  vpc_security_group_ids  = [var.eks_cluster_securitygroup]

  db_proxy_endpoints = {
    read_write = {
      name                   = "read-write-endpoint"
      vpc_subnet_ids         = var.vpc_private_subnets
      vpc_security_group_ids = [var.eks_cluster_securitygroup]
    },
    read_only = {
      name                   = "read-only-endpoint"
      vpc_subnet_ids         = var.vpc_private_subnets
      vpc_security_group_ids = [var.eks_cluster_securitygroup]
      target_role            = "READ_ONLY"
    }
  }

  secrets = {
    local.db_user = {
      description = aws_secretsmanager_secret.superuser.description
      arn         = aws_secretsmanager_secret.superuser.arn
      kms_key_id  = var.kms_arn
    }
  }

  engine_family = "POSTGRESQL"
  db_host       = aws_rds_cluster.notification-canada-ca.endpoint
  db_name       = aws_rds_cluster.notification-canada-ca.database_name

  # Target Aurora cluster
  target_db_cluster     = true
  db_cluster_identifier = aws_rds_cluster.notification-canada-ca.cluster_identifier

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}
