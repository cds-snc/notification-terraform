# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]

resource "aws_quicksight_data_set" "services" {
  data_set_id = "services"
  name        = "Services"
  import_mode = "SPICE"

  physical_table_map {
    physical_table_map_id = "services"
    custom_sql {
      data_source_arn = aws_quicksight_data_source.rds.arn
      name            = "services"
      sql_query       = <<EOF
        select s.id, s.created_at, s.updated_at, s.active, count_as_live, 
               go_live_at, restricted, s.name, organisation_id, o.name as organisation_name,
               message_limit, rate_limit, sms_daily_limit
          from services s inner join organisation o on s.organisation_id = o.id
      EOF

      columns {
        name = "id"
        type = "STRING"
      }
      columns {
        name = "created_at"
        type = "DATETIME"
      }
      columns {
        name = "updated_at"
        type = "DATETIME"
      }
      columns {
        name = "active"
        type = "BOOLEAN"
      }
      columns {
        name = "count_as_live"
        type = "BOOLEAN"
      }
      columns {
        name = "go_live_at"
        type = "DATETIME"
      }
      columns {
        name = "restricted"
        type = "STRING"
      }
      columns {
        name = "name"
        type = "STRING"
      }
      columns {
        name = "organisation_id"
        type = "STRING"
      }
      columns {
        name = "organisation_name"
        type = "STRING"
      }
      columns {
        name = "message_limit"
        type = "INTEGER"
      }
      columns {
        name = "rate_limit"
        type = "INTEGER"
      }
      columns {
        name = "sms_daily_limit"
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

resource "aws_quicksight_refresh_schedule" "services" {
  data_set_id = "services"
  schedule_id = "schedule-services"
  depends_on  = [aws_quicksight_data_set.services]

  schedule {
    refresh_type = "FULL_REFRESH"

    schedule_frequency {
      interval        = "DAILY"
      time_of_the_day = "07:25"
    }
  }
}
