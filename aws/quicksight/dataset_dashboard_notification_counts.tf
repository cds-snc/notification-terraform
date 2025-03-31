# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]

resource "aws_quicksight_data_set" "dashboard-notification-counts" {
  data_set_id = "dashboard-notification-counts"
  name        = "Dashboard notification counts"
  import_mode = "SPICE"

  lifecycle {
    ignore_changes = [
      refresh_properties,
    ]
  }

  physical_table_map {
    physical_table_map_id = "notification-counts"
    custom_sql {
      data_source_arn = aws_quicksight_data_source.rds.arn
      name            = "dashboard-notification-counts"
      sql_query       = <<EOF
WITH n AS (
          SELECT
            service_id,
            COUNT(id) AS n_count,
            DATE_PART('day', created_at) AS day
          FROM notifications
          WHERE
            created_at >= DATE_TRUNC('day', NOW()) - interval '14 days'
            AND created_at <= (DATE_TRUNC('day', NOW()) + interval '1 day' - interval '1 second')
            AND key_type <> 'test'
          GROUP BY
            DATE_PART('day', created_at),
            service_id
          ORDER BY day
        ),
        nh AS (
          SELECT
            service_id,
            COUNT(id) AS nh_count,
            DATE_PART('day', created_at) AS day
          FROM notification_history
          WHERE
            created_at >= DATE_TRUNC('day', NOW()) - interval '14 days'
            AND created_at <= (DATE_TRUNC('day', NOW()) + interval '1 day' - interval '1 second')
            AND key_type <> 'test'
          GROUP BY
            DATE_PART('day', created_at),
            service_id
          ORDER BY day, service_id
        ),
        ft AS (
          SELECT
            service_id,
            SUM(notification_count) AS ft_count,
            DATE_PART('day', bst_date) AS day
          FROM ft_notification_status
          WHERE
            bst_date >= DATE_TRUNC('day', NOW()) - interval '14 days'
            AND bst_date <= (DATE_TRUNC('day', NOW()) + interval '1 day' - interval '1 second')
            AND key_type <> 'test'
          GROUP BY
            DATE_PART('day', bst_date),
            service_id
          ORDER BY day
        )
        SELECT
          COALESCE(n.service_id, nh.service_id, ft.service_id) AS service_id,
          COALESCE(n.day, nh.day, ft.day) AS day,
          n.n_count,
          nh.nh_count,
          ft.ft_count,
          CASE
            WHEN nh.nh_count IS NOT NULL AND ft.ft_count IS NOT NULL AND nh.nh_count <> ft.ft_count THEN '❌'
            ELSE '✅'
          END AS count_comparison
        FROM n
        FULL OUTER JOIN nh
          ON n.day = nh.day AND n.service_id = nh.service_id
        FULL OUTER JOIN ft
          ON COALESCE(n.day, nh.day) = ft.day
          AND COALESCE(n.service_id, nh.service_id) = ft.service_id
        ORDER BY day, service_id
      EOF

      columns {
        name = "service_id"
        type = "STRING"
      }
      columns {
        name = "day"
        type = "INTEGER"
      }
      columns {
        name = "n_count"
        type = "INTEGER"
      }
      columns {
        name = "nh_count"
        type = "INTEGER"
      }
      columns {
        name = "ft_count"
        type = "INTEGER"
      }
      columns {
        name = "count_comparison"
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

resource "aws_quicksight_refresh_schedule" "dashboard-notification-counts" {
  data_set_id = "dashboard-notification-counts"
  schedule_id = "schedule-dashboard-notification-counts"
  depends_on  = [aws_quicksight_data_set.dashboard-notification-counts]

  schedule {
    refresh_type = "FULL_REFRESH"

    schedule_frequency {
      interval        = "DAILY"
      time_of_the_day = "01:00"
    }
  }
}