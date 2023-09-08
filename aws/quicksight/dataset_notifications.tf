# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]

resource "aws_quicksight_data_set" "notifications" {
  data_set_id = "notifications"
  name        = "Notifications"
  import_mode = "SPICE"

  physical_table_map {
    physical_table_map_id = "notifications"
    relational_table {
      data_source_arn = aws_quicksight_data_source.rds.arn
      name            = "notifications"
      input_columns {
        name = "id"
        type = "STRING"
      }
      input_columns {
        name = "template_id"
        type = "STRING"
      }
      input_columns {
        name = "template_version"
        type = "INTEGER"
      }
      input_columns {
        name = "service_id"
        type = "STRING"
      }
      input_columns {
        name = "job_id"
        type = "STRING"
      }
      input_columns {
        name = "notification_type"
        type = "STRING"
      }
      input_columns {
        name = "notification_status"
        type = "STRING"
      }
      input_columns {
        name = "created_at"
        type = "DATETIME"
      }
      input_columns {
        name = "sent_at"
        type = "DATETIME"
      }
      input_columns {
        name = "updated_at"
        type = "DATETIME"
      }
    }
  }
  permissions {
    actions = [
      "quicksight:DescribeDataSet",
      "quicksight:DescribeDataSetPermissions",
      "quicksight:PassDataSet",
      "quicksight:DescribeIngestion",
      "quicksight:ListIngestions",
    ]
    principal = aws_quicksight_group.dataset_viewer.arn
  }
  permissions {
    actions = [
      "quicksight:ListIngestions",
      "quicksight:DeleteDataSet",
      "quicksight:UpdateDataSetPermissions",
      "quicksight:CancelIngestion",
      "quicksight:UpdateDataSet",
      "quicksight:DescribeDataSetPermissions",
      "quicksight:DescribeDataSet",
      "quicksight:PassDataSet",
      "quicksight:CreateIngestion",
      "quicksight:DescribeIngestion"
    ]
    principal = aws_quicksight_group.dataset_full.arn
  }
}
