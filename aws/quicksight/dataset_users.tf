# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]

resource "aws_quicksight_data_set" "users" {
  data_set_id = "users"
  name        = "Users"
  import_mode = "SPICE"

  lifecycle {
    ignore_changes = [
      refresh_properties,
    ]
  }

  physical_table_map {
    physical_table_map_id = "users"
    relational_table {
      data_source_arn = aws_quicksight_data_source.rds.arn
      name            = "users"
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
        name = "email_address"
        type = "STRING"
      }
      input_columns {
        name = "mobile_number"
        type = "STRING"
      }
      input_columns {
        name = "password_changed_at"
        type = "DATETIME"
      }
      input_columns {
        name = "logged_in_at"
        type = "DATETIME"
      }
      input_columns {
        name = "state"
        type = "STRING"
      }
      input_columns {
        name = "platform_admin"
        type = "BOOLEAN"
      }
      input_columns {
        name = "auth_type"
        type = "STRING"
      }
      input_columns {
        name = "blocked"
        type = "BOOLEAN"
      }
      input_columns {
        name = "password_expired"
        type = "BOOLEAN"
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

resource "aws_quicksight_refresh_schedule" "users" {
  data_set_id = "users"
  schedule_id = "schedule-users"
  depends_on  = [aws_quicksight_data_set.users]

  schedule {
    refresh_type = "FULL_REFRESH"

    schedule_frequency {
      interval        = "DAILY"
      time_of_the_day = "07:40"
    }
  }
}
