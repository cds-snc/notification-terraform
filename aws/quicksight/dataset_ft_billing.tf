# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]

resource "aws_quicksight_data_set" "ft_billing" {
  data_set_id = "ft_billing"
  name        = "FactBilling"
  import_mode = "SPICE"

  lifecycle {
    ignore_changes = [
      refresh_properties,
    ]
  }

  physical_table_map {
    physical_table_map_id = "ft-billing"
    relational_table {
      data_source_arn = aws_quicksight_data_source.rds.arn
      name            = "ft_billing"

      input_columns {
        name = "bst_date"
        type = "DATETIME"
      }
      input_columns {
        name = "updated_at"
        type = "DATETIME"
      }
      input_columns {
        name = "created_at"
        type = "DATETIME"
      }
      input_columns {
        name = "template_id"
        type = "STRING"
      }
      input_columns {
        name = "service_id"
        type = "STRING"
      }
      input_columns {
        name = "notification_type"
        type = "STRING"
      }
      input_columns {
        name = "provider"
        type = "STRING"
      }
      input_columns {
        name = "rate_multiplier"
        type = "INTEGER"
      }
      input_columns {
        name = "international"
        type = "BOOLEAN"
      }
      input_columns {
        name = "rate"
        type = "DECIMAL"
      }
      input_columns {
        name = "billable_units"
        type = "INTEGER"
      }
      input_columns {
        name = "notifications_sent"
        type = "INTEGER"
      }
      input_columns {
        name = "postage"
        type = "STRING"
      }
      input_columns {
        name = "sms_sending_vehicle"
        type = "STRING"
      }
      input_columns {
        name = "billing_total"
        type = "DECIMAL"
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

resource "aws_quicksight_refresh_schedule" "ft_billing" {
  data_set_id = "ft_billing"
  schedule_id = "schedule-ft-billing"
  depends_on  = [aws_quicksight_data_set.ft_billing]

  schedule {
    refresh_type = "FULL_REFRESH"

    schedule_frequency {
      interval        = "DAILY"
      time_of_the_day = "07:45"
    }
  }
}
