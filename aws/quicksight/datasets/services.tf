# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]

resource "aws_quicksight_data_set" "services" {
  data_set_id = "services"
  name        = "Services"
  import_mode = "SPICE"

  physical_table_map {
    physical_table_map_id = "services"
    relational_table {
      data_source_arn = aws_quicksight_data_source.rds.arn
      name            = "services"
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
        name = "active"
        type = "BOOLEAN"
      }
      input_columns {
        name = "count_as_live"
        type = "BOOLEAN"
      }
      input_columns {
        name = "go_live_at"
        type = "DATETIME"
      }
      input_columns {
        name = "name"
        type = "STRING"
      }
      input_columns {
        name = "message_limit"
        type = "INTEGER"
      }
      input_columns {
        name = "rate_limit"
        type = "INTEGER"
      }
      input_columns {
        name = "sms_limit"
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
