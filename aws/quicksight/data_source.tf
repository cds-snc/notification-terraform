resource "aws_quicksight_data_source" "rds" {
  depends_on     = [aws_iam_role_policy_attachment.rds-qs-attach]
  data_source_id = var.database_name
  name           = "Quicksight RDS data source"
  ssl_properties {
    disable_ssl = false
  }
  credentials {
    credential_pair {
      username = var.quicksight_db_user_name
      password = var.quicksight_db_user_password
    }
  }
  vpc_connection_properties {
    vpc_connection_arn = aws_quicksight_vpc_connection.rds.arn
  }
  parameters {
    rds {
      database    = var.database_name
      instance_id = var.rds_instance_id
    }
  }
  type = "POSTGRESQL"
}
