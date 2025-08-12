# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]
# We have to use a cloudformation stack here because the provider has a bug in it
# Ref: https://github.com/hashicorp/terraform-provider-aws/issues/34199

resource "aws_quicksight_data_set" "notifications_refreshed" {
  data_set_id = "notifications-refreshed"
  name        = "Notifications Refreshing"
  import_mode = "SPICE"

  lifecycle {
    ignore_changes = [
      refresh_properties,
    ]
  }

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
        name = "billable_units"
        type = "INTEGER"
      }
      input_columns {
        name = "created_at"
        type = "DATETIME"
      }
      input_columns {
        name = "queue_name"
        type = "STRING"
      }
      input_columns {
        name = "sent_at"
        type = "DATETIME"
      }
      input_columns {
        name = "notification_status"
        type = "STRING"
      }
      input_columns {
        name = "notification_type"
        type = "STRING"
      }
      input_columns {
        name = "updated_at"
        type = "DATETIME"
      }
      input_columns {
        name = "job_id"
        type = "STRING"
      }
      input_columns {
        name = "api_key_id"
        type = "STRING"
      }
      input_columns {
        name = "key_id"
        type = "STRING"
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
        name = "reference"
        type = "STRING"
      }
      input_columns {
        name = "sms_total_message_price"
        type = "DECIMAL-FLOAT"
      }
      input_columns {
        name = "sms_total_carrier_fee"
        type = "DECIMAL-FLOAT"
      }
      input_columns {
        name = "sms_iso_country_code"
        type = "STRING"
      }
      input_columns {
        name = "sms_carrier_name"
        type = "STRING"
      }
      input_columns {
        name = "sms_message_encoding"
        type = "STRING"
      }
      input_columns {
        name = "sms_origination_phone_number"
        type = "STRING"
      }
    }
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
        name = "active"
        type = "INTEGER"
      }
      input_columns {
        name = "restricted"
        type = "INTEGER"
      }
      input_columns {
        name = "research_mode"
        type = "INTEGER"
      }
      input_columns {
        name = "count_as_live"
        type = "INTEGER"
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
    logical_table_map_id = "notifications-with-services"
    alias                = "Notifications with Services"

    source {
      join_instruction {
        left_operand  = "notifications"
        right_operand = "services"

        type = "INNER" # can also be LEFT, RIGHT, OUTER, etc.

        on_clause = "notifications.service_id = services.id"
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

resource "aws_quicksight_refresh_schedule" "notifications-refreshed" {
  data_set_id = "notifications-refreshed"
  schedule_id = "schedule-notifications"
  depends_on  = [aws_quicksight_data_set.notifications]

  schedule {
    refresh_type = "INCREMENTAL_REFRESH"

    schedule_frequency {
      interval        = "DAILY"
      time_of_the_day = "07:50"
    }
  }
}
