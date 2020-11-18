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
  preferred_maintenance_window = "wed:04:00-wed:04:30"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_rds_cluster" "notification-canada-ca" {
  cluster_identifier           = "notification-canada-ca-${var.env}-cluster"
  engine                       = "aurora-postgresql"
  engine_version               = 11.8
  database_name                = "NotificationCanadaCa${var.env}"
  final_snapshot_identifier    = "server-${random_string.random.result}"
  master_username              = "postgres"
  master_password              = var.rds_cluster_password
  backup_retention_period      = 8
  preferred_backup_window      = "07:00-09:00"
  preferred_maintenance_window = "wed:04:00-wed:04:30"
  db_subnet_group_name         = aws_db_subnet_group.notification-canada-ca.name
  storage_encrypted            = true
  deletion_protection          = true


  vpc_security_group_ids = [
    var.eks_cluster_securitygroup
  ]

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_db_event_subscription" "notification-canada-ca" {
  name      = "notification-canada-ca-events-subscription"
  sns_topic = var.sns_alert_warning_arn

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
