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
  performance_insights_enabled = true

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_rds_cluster" "notification-canada-ca" {
  cluster_identifier        = "notification-canada-ca-${var.env}-cluster"
  engine                    = "aurora"
  database_name             = "notification-canada-ca-${var.env}"
  final_snapshot_identifier = "server-${random_string.random.result}"
  master_username           = "postgres"
  master_password           = var.rds_cluster_password
  backup_retention_period   = 1
  preferred_backup_window   = "07:00-09:00"
  db_subnet_group_name      = aws_db_subnet_group.notification-canada-ca.name
  storage_encrypted         = true


  vpc_security_group_ids = [
    var.eks_cluster_securitygroup
  ]

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}
