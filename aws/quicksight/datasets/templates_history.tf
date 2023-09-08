# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]

resource "aws_quicksight_data_set" "templates_history" {
  data_set_id = "templates_history"
  name        = "Templates history"
  import_mode = "SPICE"

  physical_table_map {
    physical_table_map_id = "templates_history"
    relational_table {
      data_source_arn = aws_quicksight_data_source.rds.arn
      name            = "templates_history"
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
        name = "name"
        type = "STRING"
      }
      input_columns {
        name = "process_type"
        type = "STRING"
      }
      input_columns {
        name = "service_id"
        type = "STRING"
      }
      input_columns {
        name = "template_type"
        type = "STRING"
      }
      input_columns {
        name = "version"
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
