
resource "aws_quicksight_data_source" "default" {
  depends_on     = [aws_iam_role_policy_attachment.rds-qs-attach]
  data_source_id = var.database_name
  name           = "datas source"

  credentials {
    credential_pair {
      username = local.quicksight_user_name
      password = var.quicksight_user_password
    }
  }
  vpc_connection_properties {
    vpc_connection_arn = aws_quicksight_vpc_connection.example.arn
  }
  parameters {
    rds {
      database    = var.database_name
      instance_id = "test"
    }
  }
  type = "POSTGRESQL"
}
