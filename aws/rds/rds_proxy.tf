
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
    "superuser" = {
      description = "Aurora PostgreSQL superuser password"
      arn         = "arn:aws:secretsmanager:us-east-1:123456789012:secret:superuser-6gsjLD"
      kms_key_id  = "6ca29066-552a-46c5-a7d7-7bf9a15fc255"
    }
  }

  engine_family = "POSTGRESQL"
#   db_host       = "myendpoint.cluster-custom-123456789012.${var.region}.rds.amazonaws.com"
#   db_name       = "example"
  db_host       = module.rds.rds_cluster_endpoint
  db_name       = module.rds.rds_cluster_database_name

  # Target Aurora cluster
  target_db_cluster     = true
  db_cluster_identifier = aws_rds_cluster.notification-canada-ca.cluster_identifier

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}
