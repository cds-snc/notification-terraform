# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]

resource "aws_quicksight_data_set" "services_history" {
  data_set_id = "services_history"
  name        = "Services history"
  import_mode = "SPICE"

  physical_table_map {
    physical_table_map_id = "services_history"
    relational_table {
      data_source_arn = aws_quicksight_data_source.rds.arn
      name            = "services_history"
      input_columns {
        name = "id"
        type = "STRING"
      }
      input_columns {
        name = "version"
        type = "INTEGER"
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
    actions   = local.dataset_viewer_permissions
    principal = aws_quicksight_group.dataset_viewer.arn
  }
  permissions {
    actions   = local.dataset_owner_permissions
    principal = aws_quicksight_group.dataset_owner.arn
  }
}
