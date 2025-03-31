# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]

resource "aws_quicksight_data_set" "jobs" {
  data_set_id = "jobs"
  name        = "Jobs"
  import_mode = "SPICE"

  lifecycle {
    ignore_changes = [
      refresh_properties,
    ]
  }

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
    actions   = local.dataset_viewer_permissions
    principal = aws_quicksight_group.dataset_viewer.arn
  }
  permissions {
    actions   = local.dataset_owner_permissions
    principal = aws_quicksight_group.dataset_owner.arn
  }
}

resource "aws_quicksight_refresh_schedule" "jobs" {
  data_set_id = "jobs"
  schedule_id = "schedule-jobs"
  depends_on  = [aws_quicksight_data_set.jobs]

  schedule {
    refresh_type = "FULL_REFRESH"

    schedule_frequency {
      interval        = "DAILY"
      time_of_the_day = "07:15"
    }
  }
}
