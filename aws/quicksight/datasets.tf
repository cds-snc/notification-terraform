resource "aws_quicksight_data_set" "notifications" {
  data_set_id = "notifications"
  name        = "Notifications"
  import_mode = "SPICE"

  physical_table_map {
    physical_table_map_id = "notifications"
    relational_table {
      data_source_arn = aws_quicksight_data_source.rds.arn
      name            = "notifications"
      input_columns {
        name = "id"
        type = "STRING"  # [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]
      }
      #   input_columns = [
      #     {
      #       name = "id"
      #       type = "string"
      #     },
      #     {
      #       name = "template_id"
      #       type = "string"
      #     },
      #     {
      #       name = "template_version"
      #       type = "string"
      #     },
      #     {
      #       name = "service_id"
      #       type = "string"
      #     },
      #     {
      #       name = "job_id"
      #       type = "string"
      #     },
      #     {
      #       name = "notification_type"
      #       type = "string"
      #     },
      #     {
      #       name = "notification_status"
      #       type = "string"
      #     },
      #     {
      #       name = "created_at"
      #       type = "date"
      #     },
      #     {
      #       name = "sent_at"
      #       type = "date"
      #     },
      #     {
      #       name = "updated_at"
      #       type = "date"
      #     }
      #   ]
    }
  }
}
