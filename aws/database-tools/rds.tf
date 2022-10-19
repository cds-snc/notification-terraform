resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}


resource "aws_db_instance" "database-tools" {
  allocated_storage   = 10
  name                = "database_tools"
  engine              = "postgresql"
  engine_version      = "14.3"
  instance_class      = "db.t3.micro"
  username            = "postgres"
  password            = var.dbtools_password
  skip_final_snapshot = true

  storage_encrypted   = true
  deletion_protection = true

  vpc_security_group_ids = [var.database-tools-db-securitygroup]
  db_subnet_group_name   = var.vpc_private_subnets[0]

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
