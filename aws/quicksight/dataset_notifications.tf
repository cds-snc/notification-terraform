# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]

resource "aws_quicksight_data_set" "notifications_athena" {
  data_set_id = "notifications_athena"
  name        = "Notifications_Athena"
  import_mode = "SPICE"

  lifecycle {
    ignore_changes = [
      refresh_properties,
    ]
  }

  physical_table_map {
    physical_table_map_id = "notifications-athena"
    relational_table {
      data_source_arn = aws_quicksight_data_source.athena_source.arn
      schema          = "notification_quicksight"
      name            = "vw_notification"

      input_columns {
        name = "notification_id"
        type = "STRING"
      }
      input_columns {
        name = "notification_billable_units"
        type = "INTEGER"
      }
      input_columns {
        name = "notification_created_at"
        type = "DATETIME"
      }
      input_columns {
        name = "notification_sent_at"
        type = "DATETIME"
      }
      input_columns {
        name = "notification_updated_at"
        type = "DATETIME"
      }
      input_columns {
        name = "notification_queue_name"
        type = "STRING"
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
        name = "notification_reference"
        type = "STRING"
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
        name = "api_key_type"
        type = "STRING"
      }
      input_columns {
        name = "service_id"
        type = "STRING"
      }
      input_columns {
        name = "service_active"
        type = "BOOLEAN"
      }
      input_columns {
        name = "service_restricted"
        type = "BOOLEAN"
      }
      input_columns {
        name = "service_research_mode"
        type = "BOOLEAN"
      }
      input_columns {
        name = "service_count_as_live"
        type = "BOOLEAN"
      }
      input_columns {
        name = "service_go_live_at"
        type = "DATETIME"
      }
      input_columns {
        name = "service_name"
        type = "STRING"
      }
      input_columns {
        name = "service_message_limit"
        type = "INTEGER"
      }
      input_columns {
        name = "service_rate_limit"
        type = "INTEGER"
      }
      input_columns {
        name = "service_sms_daily_limit"
        type = "INTEGER"
      }
      input_columns {
        name = "organisation_name"
        type = "STRING"
      }
      input_columns {
        name = "organisation_id"
        type = "STRING"
      }
      input_columns {
        name = "template_id"
        type = "STRING"
      }
      input_columns {
        name = "template_created_at"
        type = "DATETIME"
      }
      input_columns {
        name = "template_name"
        type = "STRING"
      }
      input_columns {
        name = "template_updated_at"
        type = "DATETIME"
      }
      input_columns {
        name = "template_version"
        type = "INTEGER"
      }
      input_columns {
        name = "tc_id"
        type = "STRING"
      }
      input_columns {
        name = "tc_name_en"
        type = "STRING"
      }
      input_columns {
        name = "tc_name_fr"
        type = "STRING"
      }
      input_columns {
        name = "tc_email_process_type"
        type = "STRING"
      }
      input_columns {
        name = "tc_sms_process_type"
        type = "STRING"
      }
      input_columns {
        name = "tc_sms_sending_vehicle"
        type = "STRING"
      }
      input_columns {
        name = "sms_total_message_price"
        type = "DECIMAL"
      }
      input_columns {
        name = "sms_total_carrier_fee"
        type = "DECIMAL"
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
  permissions {
    actions   = local.dataset_viewer_permissions
    principal = aws_quicksight_group.dataset_viewer.arn
  }
  permissions {
    actions   = local.dataset_owner_permissions
    principal = aws_quicksight_group.dataset_owner.arn
  }
}

resource "aws_quicksight_refresh_schedule" "notifications_athena_schedule" {
  data_set_id = "notifications_athena"
  schedule_id = "schedule-notifications-athena-v2"
  depends_on  = [aws_quicksight_data_set.notifications_athena]

  schedule {
    refresh_type = "FULL_REFRESH"

    schedule_frequency {
      interval        = "DAILY"
      time_of_the_day = "09:20"
    }
  }

  lifecycle {
    ignore_changes = [
      schedule[0].start_after_date_time
    ]
  }
}