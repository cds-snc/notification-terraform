# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]

resource "aws_quicksight_data_set" "sms_usage" {
  data_set_id = "sms_usage"
  name        = "SmsUsage"
  import_mode = "SPICE"

  physical_table_map {
    physical_table_map_id = "smsusage"

    s3_source {
      data_source_arn = aws_quicksight_data_source.s3_sms_usage.arn

      upload_settings {
        contains_header = "true"
        delimiter       = ","
        format          = "CSV"
      }

      input_columns {
        name = "PublishTimeUTC"
        type = "STRING"
      }
      input_columns {
        name = "MessageId"
        type = "STRING"
      }
      input_columns {
        name = "MessageType"
        type = "STRING"
      }
      input_columns {
        name = "DeliveryStatus"
        type = "STRING"
      }
      input_columns {
        name = "PriceInUSD"
        type = "DECIMAL"
      }
      input_columns {
        name = "PartNumber"
        type = "INTEGER"
      }
      input_columns {
        name = "TotalParts"
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

resource "aws_quicksight_refresh_schedule" "sms_usage" {
  data_set_id = "sms_usage"
  schedule_id = "schedule-sms-usage"
  depends_on  = [aws_quicksight_data_set.sms_usage]

  schedule {
    refresh_type = "INCREMENTAL_REFRESH"

    # SMS usage reports are generated around 01:00 UTC.
    schedule_frequency {
      interval        = "DAILY"
      time_of_the_day = "02:30"
    }
  }
}
