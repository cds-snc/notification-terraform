# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]

resource "aws_quicksight_data_set" "services" {
  data_set_id = "services"
  name        = "Services"
  import_mode = "SPICE"

  permissions {
    actions   = local.dataset_viewer_permissions
    principal = aws_quicksight_group.dataset_viewer.arn
  }
  permissions {
    actions   = local.dataset_owner_permissions
    principal = aws_quicksight_group.dataset_owner.arn
  }

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
        name = "sms_daily_limit"
        type = "INTEGER"
      }
    }
  }

  logical_table_map {
    alias                = "services"
    logical_table_map_id = "services"
    source {
      physical_table_id = "services"
    }
    data_transforms {
      rename_column_operation {
        column_name     = "id"
        new_column_name = "service_id"
      }
    }
    data_transforms {
      rename_column_operation {
        column_name     = "updated_at"
        new_column_name = "service_updated_at"
      }
    }
    data_transforms {
      rename_column_operation {
        column_name     = "created_at"
        new_column_name = "service_created_at"
      }
    }
    data_transforms {
      rename_column_operation {
        column_name     = "active"
        new_column_name = "service_active"
      }
    }
    data_transforms {
      rename_column_operation {
        column_name     = "count_as_live"
        new_column_name = "service_count_as_live"
      }
    }
    data_transforms {
      rename_column_operation {
        column_name     = "go_live_at"
        new_column_name = "service_go_live_at"
      }
    }
    data_transforms {
      rename_column_operation {
        column_name     = "name"
        new_column_name = "service_name"
      }
    }
    data_transforms {
      rename_column_operation {
        column_name     = "message_limit"
        new_column_name = "service_message_limit"
      }
    }
    data_transforms {
      rename_column_operation {
        column_name     = "rate_limit"
        new_column_name = "service_rate_limit"
      }
    }
    data_transforms {
      rename_column_operation {
        column_name     = "sms_daily_limit"
        new_column_name = "service_sms_daily_limit"
      }
    }
  }
}
