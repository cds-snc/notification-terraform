# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]

resource "aws_quicksight_data_set" "templates" {
  data_set_id = "templatesv2"
  name        = "TemplatesV2"
  import_mode = "SPICE"

  permissions {
    actions   = local.dataset_viewer_permissions
    principal = aws_quicksight_group.dataset_viewer.arn
  }
  permissions {
    actions   = local.dataset_owner_permissions
    principal = aws_quicksight_group.dataset_owner.arn
  }

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

  logical_table_map {
    alias                = "templates"
    logical_table_map_id = "templates"
    source {
      physical_table_id = "templates"
    }
    data_transforms {
      rename_column_operation {
        column_name     = "id"
        new_column_name = "template_id"
      }
    }
    data_transforms {
      rename_column_operation {
        column_name     = "updated_at"
        new_column_name = "template_updated_at"
      }
    }
    data_transforms {
      rename_column_operation {
        column_name     = "created_at"
        new_column_name = "template_created_at"
      }
    }
    data_transforms {
      rename_column_operation {
        column_name     = "name"
        new_column_name = "template_name"
      }
    }
    data_transforms {
      rename_column_operation {
        column_name     = "process_type"
        new_column_name = "template_process_type"
      }
    }
    data_transforms {
      rename_column_operation {
        column_name     = "version"
        new_column_name = "template_version"
      }
    }
  }
}
