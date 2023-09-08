# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]

resource "aws_quicksight_data_set" "templates" {
  data_set_id = "templates"
  name        = "Templates"
  import_mode = "SPICE"

  physical_table_map {
    physical_table_map_id = "templates"
    relational_table {
      data_source_arn = aws_quicksight_data_source.rds.arn
      name            = "templates"
      input_columns {
        name = "id"
        type = "STRING"
      }
      input_columns {
        name = "created_at"
        type = "DATETIME"
      }
      input_columns {
        name = "updated_at"
        type = "DATETIME"
      }
      input_columns {
        name = "name"
        type = "STRING"
      }
      input_columns {
        name = "process_type"
        type = "STRING"
      }
      input_columns {
        name = "service_id"
        type = "STRING"
      }
      input_columns {
        name = "template_type"
        type = "STRING"
      }
      input_columns {
        name = "version"
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
