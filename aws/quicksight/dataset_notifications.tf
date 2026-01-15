# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]

resource "aws_quicksight_data_set" "notifications" {
  count = var.env == "production" ? 1 : 0

  data_set_id = "notifications"
  name        = "Notifications"
  import_mode = "SPICE"

  lifecycle {
    ignore_changes = [
      refresh_properties,
    ]
  }

  physical_table_map {
    physical_table_map_id = "notifications"
    custom_sql {
      data_source_arn = aws_quicksight_data_source.rds.arn
      name            = "notifications"
      sql_query       = <<EOF
        with notification_data as (
            select 
              id as notification_id,
              billable_units as notification_billable_units,
              created_at as notification_created_at,
              queue_name as notification_queue_name,
              sent_at as notification_sent_at,
              notification_status,
              notification_type,
              updated_at notification_updated_at,
              job_id,
              api_key_id,
              key_type as api_key_type,
              service_id,
              template_id,
              reference as notification_reference,
              sms_total_message_price,
              sms_total_carrier_fee,
              sms_iso_country_code,
              sms_carrier_name,
              sms_message_encoding,
              sms_origination_phone_number
            from notifications
          union
            select 
              id as notification_id,
              billable_units as notification_billable_units,
              created_at as notification_created_at,
              queue_name as notification_queue_name,
              sent_at as notification_sent_at,
              notification_status,
              notification_type,
              updated_at notification_updated_at,
              job_id,
              api_key_id,
              key_type as api_key_type,
              service_id,
              template_id,
              reference as notification_reference,
              sms_total_message_price,
              sms_total_carrier_fee,
              sms_iso_country_code,
              sms_carrier_name,
              sms_message_encoding,
              sms_origination_phone_number
            from notification_history
        ),
        service_data as (
          select
            s.id as service_id,
            s.active as service_active,
            s.restricted as service_restricted,
            s.research_mode as service_research_mode,
            count_as_live as service_count_as_live,
            s.go_live_at as service_go_live_at,
            s.name as service_name,
            s.message_limit as service_message_limit,
            s.rate_limit as service_rate_limit,
            s.sms_daily_limit as service_sms_daily_limit,
            o.name as organisation_name,
            s.organisation_id
          from services s join organisation o on s.organisation_id = o.id
        ),
        template_data as (
          select
            t.id as template_id,
            t.created_at as template_created_at,
            t.name as template_name,
            t.updated_at as template_updated_at,
            t.version as template_version,
            tc.id as tc_id, 
            tc.name_en as tc_name_en, 
            tc.name_fr as tc_name_fr, 
            tc.email_process_type as tc_email_process_type, 
            tc.sms_process_type as tc_sms_process_type, 
            tc.sms_sending_vehicle as tc_sms_sending_vehicle
          from templates t
          left outer join template_categories tc on tc.id = t.template_category_id
        )
        select
          notification_id, notification_billable_units, notification_created_at, notification_sent_at, notification_status,
          notification_queue_name, notification_type, notification_updated_at, 
          notification_reference, job_id, api_key_id, api_key_type,
          sms_total_message_price, sms_total_carrier_fee, sms_iso_country_code, sms_carrier_name, sms_message_encoding, sms_origination_phone_number,
          s.*, t.*
        from notification_data n 
          join service_data s on n.service_id = s.service_id
          join template_data t on n.template_id = t.template_id
      EOF

      columns {
        name = "notification_id"
        type = "STRING"
      }
      columns {
        name = "notification_billable_units"
        type = "INTEGER"
      }
      columns {
        name = "notification_created_at"
        type = "DATETIME"
      }
      columns {
        name = "notification_sent_at"
        type = "DATETIME"
      }
      columns {
        name = "notification_updated_at"
        type = "DATETIME"
      }
      columns {
        name = "notification_queue_name"
        type = "STRING"
      }
      columns {
        name = "notification_status"
        type = "STRING"
      }
      columns {
        name = "notification_type"
        type = "STRING"
      }
      columns {
        name = "notification_reference"
        type = "STRING"
      }
      columns {
        name = "job_id"
        type = "STRING"
      }
      columns {
        name = "api_key_id"
        type = "STRING"
      }
      columns {
        name = "api_key_type"
        type = "STRING"
      }
      columns {
        name = "service_id"
        type = "STRING"
      }
      columns {
        name = "service_active"
        type = "BOOLEAN"
      }
      columns {
        name = "service_restricted"
        type = "BOOLEAN"
      }
      columns {
        name = "service_research_mode"
        type = "BOOLEAN"
      }
      columns {
        name = "service_count_as_live"
        type = "BOOLEAN"
      }
      columns {
        name = "service_go_live_at"
        type = "DATETIME"
      }
      columns {
        name = "service_name"
        type = "STRING"
      }
      columns {
        name = "service_message_limit"
        type = "INTEGER"
      }
      columns {
        name = "service_rate_limit"
        type = "INTEGER"
      }
      columns {
        name = "service_sms_daily_limit"
        type = "INTEGER"
      }
      columns {
        name = "organisation_name"
        type = "STRING"
      }
      columns {
        name = "organisation_id"
        type = "STRING"
      }
      columns {
        name = "template_id"
        type = "STRING"
      }
      columns {
        name = "template_created_at"
        type = "DATETIME"
      }
      columns {
        name = "template_name"
        type = "STRING"
      }
      columns {
        name = "template_updated_at"
        type = "DATETIME"
      }
      columns {
        name = "template_version"
        type = "INTEGER"
      }
      columns {
        name = "tc_id"
        type = "STRING"
      }
      columns {
        name = "tc_name_en"
        type = "STRING"
      }
      columns {
        name = "tc_name_fr"
        type = "STRING"
      }
      columns {
        name = "tc_email_process_type"
        type = "STRING"
      }
      columns {
        name = "tc_sms_process_type"
        type = "STRING"
      }
      columns {
        name = "tc_sms_sending_vehicle"
        type = "STRING"
      }
      columns {
        name = "sms_total_message_price"
        type = "DECIMAL"
      }
      columns {
        name = "sms_total_carrier_fee"
        type = "DECIMAL"
      }
      columns {
        name = "sms_iso_country_code"
        type = "STRING"
      }
      columns {
        name = "sms_carrier_name"
        type = "STRING"
      }
      columns {
        name = "sms_message_encoding"
        type = "STRING"
      }
      columns {
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

resource "aws_quicksight_refresh_schedule" "notifications" {
  count = var.env == "production" ? 1 : 0

  data_set_id = "notifications"
  schedule_id = "schedule-notifications"
  depends_on  = [aws_quicksight_data_set.notifications]

  schedule {
    refresh_type = "FULL_REFRESH"

    schedule_frequency {
      interval        = "DAILY"
      time_of_the_day = "05:10"
    }
  }
}

resource "aws_quicksight_data_set" "notifications_athena" {
  count = var.env == "staging" ? 1 : 0

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

resource "aws_quicksight_refresh_schedule" "notifications_athena" {
  count = var.env == "staging" ? 1 : 0

  data_set_id = "notifications_athena"
  schedule_id = "schedule-notifications-athena"
  depends_on  = [aws_quicksight_data_set.notifications_athena]

  schedule {
    refresh_type = "FULL_REFRESH"

    schedule_frequency {
      interval        = "DAILY"
      time_of_the_day = "05:20"
    }
  }
}