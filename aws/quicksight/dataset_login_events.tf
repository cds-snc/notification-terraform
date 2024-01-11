# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]

resource "aws_quicksight_data_set" "login_events" {
  data_set_id = "login-events"
  name        = "Login Events"
  import_mode = "SPICE"

  physical_table_map {
    physical_table_map_id = "login-events"
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

  refresh_properties {
    refresh_configuration {
      incremental_refresh {
        lookback_window {
          column_name = "created_at"
          size        = 1
          size_unit   = "DAY"
        }
      }
    }
  }
}

resource "aws_quicksight_refresh_schedule" "login_events" {
  data_set_id = "login-events"
  schedule_id = "schedule-login-events"
  depends_on  = [aws_quicksight_data_set.login_events]

  schedule {
    refresh_type = "INCREMENTAL_REFRESH"

    schedule_frequency {
      interval        = "DAILY"
      time_of_the_day = "07:10"
    }
  }
}
