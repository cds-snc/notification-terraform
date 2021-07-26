resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_db_subnet_group" "notification-canada-ca" {
  name       = "notification-canada-ca-${var.env}"
  subnet_ids = var.vpc_private_subnets

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_rds_cluster_instance" "notification-canada-ca-instances" {
  count                        = var.rds_instance_count
  identifier                   = "notification-canada-ca-${var.env}-instance-${count.index}"
  cluster_identifier           = aws_rds_cluster.notification-canada-ca.id
  instance_class               = var.rds_instance_type
  db_subnet_group_name         = aws_db_subnet_group.notification-canada-ca.name
  engine                       = aws_rds_cluster.notification-canada-ca.engine
  engine_version               = aws_rds_cluster.notification-canada-ca.engine_version
  performance_insights_enabled = true
  #tfsec:ignore:AWS053 - Encryption for RDS Perfomance Insights should be enabled.
  # Cannot set a custom KMS key after performance insights has been enabled
  # https://github.com/hashicorp/terraform-provider-aws/issues/3015#issuecomment-520667166
  preferred_maintenance_window = "wed:04:00-wed:04:30"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_rds_cluster" "notification-canada-ca" {
  cluster_identifier           = "notification-canada-ca-${var.env}-cluster"
  engine                       = "aurora-postgresql"
  engine_version               = 11.9
  database_name                = "NotificationCanadaCa${var.env}"
  final_snapshot_identifier    = "server-${random_string.random.result}"
  master_username              = "postgres"
  master_password              = var.rds_cluster_password
  backup_retention_period      = 8
  preferred_backup_window      = "07:00-09:00"
  preferred_maintenance_window = "wed:04:00-wed:04:30"
  db_subnet_group_name         = aws_db_subnet_group.notification-canada-ca.name
  #tfsec:ignore:AWS051 - database is encrypted without a custom key and that's fine
  storage_encrypted   = true
  deletion_protection = true

  vpc_security_group_ids = [
    var.eks_cluster_securitygroup
  ]

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
      engine_version
    ]
    prevent_destroy = true
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_db_event_subscription" "notification-canada-ca" {
  name      = "notification-canada-ca-events-subscription"
  sns_topic = var.sns_alert_general_arn

  source_type = "db-instance"

  # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Events.html
  event_categories = [
    "availability",
    "failover",
    "failure",
    "low storage",
    "maintenance",
  ]
}

resource "aws_db_event_subscription" "notification-canada-ca-cluster" {
  name      = "notification-canada-ca-aurora-cluster-events-subscription"
  sns_topic = var.sns_alert_general_arn

  source_type = "db-cluster"

  # See https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Events.html
  # We are interested in all events so leaving out the event_categories parameter
}

resource "aws_db_proxy" "notification-canada-ca-proxy" {
  name                   = "notification-canada-ca-proxy"
  debug_logging          = false
  engine_family          = "POSTGRESQL"
  idle_client_timeout    = 300 # 5 minutes
  require_tls            = true
  role_arn               = aws_iam_role.example.arn
  vpc_security_group_ids = [var.eks_cluster_securitygroup]
  vpc_subnet_ids         = var.vpc_private_subnets

  auth {
    auth_scheme = "SECRETS"
    description = "example"
    iam_auth    = "DISABLED"
    secret_arn  = aws_secretsmanager_secret.example.arn
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_db_proxy_default_target_group" "example" {
  db_proxy_name = aws_db_proxy.example.name

  connection_pool_config {
    connection_borrow_timeout    = 120
    init_query                   = "SET x=1, y=2"
    max_connections_percent      = 100
    max_idle_connections_percent = 50
    session_pinning_filters      = ["EXCLUDE_VARIABLE_SETS"]
  }
}

resource "aws_db_proxy_target" "example" {
  db_instance_identifier = aws_db_instance.example.id
  db_proxy_name          = aws_db_proxy.example.name
  target_group_name      = aws_db_proxy_default_target_group.example.name
}
