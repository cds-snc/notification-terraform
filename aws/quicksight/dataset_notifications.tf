# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]

resource "aws_quicksight_data_set" "notifications" {
  data_set_id = "notifications"
  name        = "notifications"
  import_mode = "SPICE"

  physical_table_map {
    physical_table_map_id = "notifications"
    custom_sql {
      data_source_arn = aws_quicksight_data_source.rds.arn
      name            = "notifications"
      sql_query       = <<EOF
        with notification_data as (
            select 
              id as notification_id,
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
              template_id
            from notifications
          union
            select 
              id as notification_id,
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
              template_id
            from notification_history
        ),
        service_data as (
          select
            s.id as service_id,
            s.active as service_active,
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
            id as template_id,
            created_at as template_created_at,
            name as template_name,
            updated_at as template_updated_at,
            version as template_version
          from templates
        )
        select
          notification_id, notification_created_at, notification_sent_at, notification_status,
          notification_queue_name, notification_type, notification_updated_at, job_id, api_key_id, api_key_type,
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
        type = "BIT"
      }
      columns {
        name = "service_count_as_live"
        type = "BIT"
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
