# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]

resource "aws_quicksight_data_set" "jobs" {
  data_set_id = "jobs"
  name        = "Jobs"
  import_mode = "SPICE"

  physical_table_map {
    physical_table_map_id = "jobs"
    relational_table {
      data_source_arn = aws_quicksight_data_source.rds.arn
      name            = "jobs"
      input_columns {
        name = "id"
        type = "STRING"
      }
      input_columns {
        name = "created_at"
        type = "DATETIME"
      }
      input_columns {
        name = "updated_at"
        type = "DATETIME"
      }
      input_columns {
        name = "api_key_id"
        type = "STRING"
      }
      input_columns {
        name = "job_status"
        type = "STRING"
      }
      input_columns {
        name = "notification_count"
        type = "INTEGER"
      }
      input_columns {
        name = "notifications_delivered"
        type = "INTEGER"
      }
      input_columns {
        name = "notifications_failed"
        type = "INTEGER"
      }
      input_columns {
        name = "notifications_sent"
        type = "INTEGER"
      }
      input_columns {
        name = "processing_finished"
        type = "DATETIME"
      }
      input_columns {
        name = "processing_started"
        type = "DATETIME"
      }
      input_columns {
        name = "scheduled_for"
        type = "DATETIME"
      }
      input_columns {
        name = "service_id"
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
