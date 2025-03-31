# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]

resource "aws_quicksight_data_set" "template-category-history" {
  data_set_id = "template-category-history"
  name        = "Template category history"
  import_mode = "SPICE"

  lifecycle {
    ignore_changes = [
      refresh_properties,
    ]
  }

  physical_table_map {
    physical_table_map_id = "tc-usage-history"
    custom_sql {
      data_source_arn = aws_quicksight_data_source.rds.arn
      name            = "template-category-history"
      sql_query       = <<EOF
        SELECT 
            from_cat.name_en AS from_category,
            to_cat.name_en AS to_category,
            COUNT(DISTINCT th1.id) AS count
        FROM 
            templates_history th1
        JOIN 
            templates_history th2 ON th1.id = th2.id
        JOIN 
            template_categories from_cat ON th1.template_category_id = from_cat.id
        JOIN 
            template_categories to_cat ON th2.template_category_id = to_cat.id
        WHERE 
            th1.updated_At < th2.updated_at
            AND th1.template_category_id != th2.template_category_id
        GROUP BY 
            from_cat.name_en, to_cat.name_en
        ORDER BY 
            count DESC
      EOF

      columns {
        name = "from_category"
        type = "STRING"
      }
      columns {
        name = "to_category"
        type = "STRING"
      }
      columns {
        name = "count"
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

resource "aws_quicksight_refresh_schedule" "template-category-history" {
  data_set_id = "template-category-history"
  schedule_id = "schedule-template-category-history"
  depends_on  = [aws_quicksight_data_set.template-category-history]

  schedule {
    refresh_type = "FULL_REFRESH"

    schedule_frequency {
      interval        = "DAILY"
      time_of_the_day = "07:45"
    }
  }
}
