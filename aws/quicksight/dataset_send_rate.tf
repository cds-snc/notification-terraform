# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]

resource "aws_quicksight_data_set" "send_rate" {
  data_set_id = "send_rate"
  name        = "Send Rate"
  import_mode = "SPICE"

  physical_table_map {
    physical_table_map_id = "sendrate"
    custom_sql {
      data_source_arn = aws_quicksight_data_source.rds.arn
      name            = "send_rate"
      sql_query       = <<EOF
       with data_nh as (
            select
                id,
                notification_type,
                sent_at, sent_at::date as day, round_minutes(sent_at, 5) as sent_minute,
                greatest(billable_units, 1) as billable_units
            from notification_history
            where sent_at is not null and sent_at >= CURRENT_DATE - INTERVAL '7 day'
        ),
        data_n as (
            select
                id,
                notification_type,
                sent_at, sent_at::date as day, round_minutes(sent_at, 5) as sent_minute,
                greatest(billable_units, 1) as billable_units
            from notifications
            where sent_at is not null and sent_at >= CURRENT_DATE - INTERVAL '7 day'
        ),
        data as (
            select * from data_nh
            union
            select * from data_n
        ),
        rollup as (
            select day, notification_type, sent_minute, count(*) / 5 as notifications_per_minute, 
              sum(billable_units)/5 as fragments_per_minute
            from data
            group by day, notification_type, sent_minute
        )
        select day, notification_type, max(notifications_per_minute) as max_notifications_per_minute, max(fragments_per_minute) as max_fragments_per_minute from rollup
        group by day, notification_type
      EOF

      columns {
        name = "day"
        type = "DATETIME"
      }
      columns {
        name = "notification_type"
        type = "STRING"
      }
      columns {
        name = "max_notifications_per_minute"
        type = "INTEGER"
      }
      columns {
        name = "max_fragments_per_minute"
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

resource "aws_quicksight_refresh_schedule" "send_rate" {
  data_set_id = "send_rate"
  schedule_id = "schedule-send-rate"
  depends_on  = [aws_quicksight_data_set.send_rate]

  schedule {
    refresh_type = "FULL_REFRESH"

    schedule_frequency {
      interval        = "DAILY"
      time_of_the_day = "04:05"
    }
  }
}
