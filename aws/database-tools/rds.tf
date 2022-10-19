resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}


resource "aws_db_instance" "database-tools" {
  allocated_storage   = 10
  db_name             = "database-tools"
  engine              = "postgresql"
  engine_version      = "14.3"
  instance_class      = "db.t3.micro"
  username            = "postgres"
  password            = var.dbtools_password
  skip_final_snapshot = true
  #tfsec:ignore:AWS051 - database is encrypted without a custom key and that's fine
  storage_encrypted   = true
  deletion_protection = true

  security_group_names = [var.database-tools-securitygroup]
  db_subnet_group_name = var.vpc_private_subnets

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

resource "aws_db_event_subscription" "database-tools" {
  name      = "database-tools"
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
