# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]

resource "aws_quicksight_data_set" "login_events" {
  data_set_id = "login_events"
  name        = "Login Events"
  import_mode = "SPICE"

  physical_table_map {
    physical_table_map_id = "login_events"
    relational_table {
      data_source_arn = aws_quicksight_data_source.rds.arn
      name            = "login_events"
      input_columns {
        name = "id"
        type = "STRING"
      }
      input_columns {
        name = "created_at"
        type = "DATETIME"
      }
      input_columns {
        name = "user_id"
        type = "STRING"
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
