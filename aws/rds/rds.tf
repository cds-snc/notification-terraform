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
  ca_cert_identifier           = "rds-ca-rsa4096-g1"
  db_subnet_group_name         = aws_db_subnet_group.notification-canada-ca.name
  engine                       = aws_rds_cluster.notification-canada-ca.engine
  engine_version               = aws_rds_cluster.notification-canada-ca.engine_version
  performance_insights_enabled = true
  # tfsec:ignore:AWS053 - Encryption for RDS Perfomance Insights should be enabled.
  # Cannot set a custom KMS key after performance insights has been enabled
  # https://github.com/hashicorp/terraform-provider-aws/issues/3015#issuecomment-520667166
  preferred_maintenance_window = "wed:04:00-wed:04:30"
  auto_minor_version_upgrade   = false
  apply_immediately            = true

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_rds_cluster_parameter_group" "postgres16" {
  name        = "rds-cluster-pg-16"
  family      = "aurora-postgresql16"
  description = "RDS customized cluster parameter group"

  parameter {
    name  = "log_min_error_statement"
    value = "debug5"
  }

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  parameter {
    name  = "log_statement"
    value = "ddl"
  }

  parameter {
    name         = "rds.logical_replication"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "rds.log_retention_period"
    value        = "4320" # 3 days (in minutes)
    apply_method = "pending-reboot"
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_rds_cluster_parameter_group" "default" {
  name        = "rds-cluster-pg"
  family      = "aurora-postgresql15"
  description = "RDS customized cluster parameter group"

  parameter {
    name  = "log_min_error_statement"
    value = "debug5"
  }

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  parameter {
    name  = "log_statement"
    value = "ddl"
  }

  parameter {
    name         = "rds.logical_replication"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "rds.log_retention_period"
    value        = "4320" # 3 days (in minutes)
    apply_method = "pending-reboot"
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

#
# Dedicated pgAudit parameter group to avoid impacting production while
# this is tested.
#
resource "aws_rds_cluster_parameter_group" "pgaudit" {
  name        = "rds-cluster-pg-audit"
  family      = "aurora-postgresql15"
  description = "RDS customized cluster parameter group that enables pgAudit"

  parameter {
    name  = "log_min_error_statement"
    value = "NOTICE"
  }

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  parameter {
    name         = "shared_preload_libraries"
    value        = "pgaudit,pg_stat_statements"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "pgaudit.log"
    value        = "read,role,write,ddl"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "rds.logical_replication"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "rds.log_retention_period"
    value        = "1440" # 1 day (in minutes)
    apply_method = "pending-reboot"
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_rds_cluster" "notification-canada-ca" {

  depends_on = [
    aws_cloudwatch_log_group.logs_exports
  ]

  cluster_identifier           = "notification-canada-ca-${var.env}-cluster"
  engine                       = "aurora-postgresql"
  engine_version               = var.rds_version
  database_name                = var.rds_database_name
  final_snapshot_identifier    = "server-${random_string.random.result}"
  master_username              = "postgres"
  master_password              = var.rds_cluster_password
  backup_retention_period      = 8
  preferred_backup_window      = "07:00-09:00"
  preferred_maintenance_window = "wed:04:00-wed:04:30"
  db_subnet_group_name         = aws_db_subnet_group.notification-canada-ca.name
  allocated_storage            = 512

  snapshot_identifier = var.recovery == true ? var.rds_snapshot_identifier : null

  #tfsec:ignore:AWS051 - database is encrypted without a custom key and that's fine
  storage_encrypted   = true
  deletion_protection = var.enable_delete_protection

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.postgres16.name
  enabled_cloudwatch_logs_exports = ["postgresql"]

  vpc_security_group_ids = [
    var.eks_cluster_securitygroup
  ]

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags
    ]
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }

}

# Holds the exported postgresql logs
resource "aws_cloudwatch_log_group" "logs_exports" {
  name = "/aws/rds/cluster/notification-canada-ca-${var.env}-cluster/postgresql"
  #checkov:skip=CKV_AWS_338:The short retention is required to respect Notify's privacy policy
  retention_in_days = 3

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

# Now that the postgresql log group is no longer conditionl, we need to update it's TF state reference.
# This can be deleted once the change has been merged to Staging.
moved {
  from = aws_cloudwatch_log_group.logs_exports[0]
  to   = aws_cloudwatch_log_group.logs_exports
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
