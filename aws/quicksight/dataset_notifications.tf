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
        name = "queue_name"
        type = "STRING"
      }
      input_columns {
        name = "billable_units"
        type = "INTEGER"
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
  permissions {
    actions   = local.dataset_viewer_permissions
    principal = aws_quicksight_group.dataset_viewer.arn
  }
  permissions {
    actions   = local.dataset_owner_permissions
    principal = aws_quicksight_group.dataset_owner.arn
  }
}
