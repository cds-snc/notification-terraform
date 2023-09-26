# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]

resource "aws_quicksight_data_set" "notification_history" {
  data_set_id = "notification_history"
  name        = "Notification history"
  import_mode = "SPICE"

  physical_table_map {
    physical_table_map_id = "notification-history"
    relational_table {
      data_source_arn = aws_quicksight_data_source.rds.arn
      name            = "notification_history"
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
        name = "queue_name"
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
      input_columns {
        name = "feedback_type"
        type = "STRING"
      }
      input_columns {
        name = "feedback_subtype"
        type = "STRING"
      }
    }
  }

  logical_table_map {
    logical_table_map_id = "nh-services"
    alias                = "Services"
    data_transforms {
      rename_column_operation {
        column_name     = "id"
        new_column_name = "id[Services]"
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
    source {
      data_set_arn = aws_quicksight_data_set.services.arn
    }
  }

  logical_table_map {
    logical_table_map_id = "nh-services-joined"
    alias                = "Intermediate Table"
    data_transforms {
      project_operation {
        projected_columns = [
          "id",
          "job_id",
          "job_row_number",
          "service_id",
          "template_id",
          "template_version",
          "api_key_id",
          "key_type",
          "notification_type",
          "created_at",
          "sent_at",
          "sent_by",
          "updated_at",
          "reference",
          "billable_units",
          "client_reference",
          "international",
          "phone_prefix",
          "rate_multiplier",
          "notification_status",
          "queue_name",
          "feedback_type",
          "feedback_subtype",
          "created_at[Services]",
          "service_active",
          "service_count_as_live",
          "service_go_live_at",
          "service_name",
          "service_message_limit",
          "service_rate_limit",
          "service_sms_daily_limit"
        ]
      }
    }
    source {
      join_instruction {
        left_operand  = "notification-history"
        right_operand = "nh-services"
        type          = "INNER"
        on_clause     = "{service_id} = {id[Services]}"
      }
    }
  }

  logical_table_map {
    logical_table_map_id = "notification-history"
    alias                = "notification_history"
    source {
      physical_table_id = "notification-history"
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
