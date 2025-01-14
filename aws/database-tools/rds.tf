resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_db_subnet_group" "database-tools-rds-subnet" {
  name       = "database-tools-rds-subnet"
  subnet_ids = var.vpc_private_subnets

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "database-tools" {
  allocated_storage   = 10
  db_name             = "database_tools"
  engine              = "postgres"
  engine_version      = var.blazer_rds_version
  instance_class      = "db.t3.micro"
  username            = "postgres"
  password            = var.dbtools_password
  ca_cert_identifier  = "rds-ca-rsa4096-g1"
  apply_immediately   = true
  skip_final_snapshot = true

  storage_encrypted   = true
  deletion_protection = var.enable_delete_protection

  backup_retention_period = 7
  backup_window           = "02:00-04:00"

  vpc_security_group_ids = [var.database-tools-db-securitygroup]
  db_subnet_group_name   = aws_db_subnet_group.database-tools-rds-subnet.name

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
      engine_version
    ]
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}
