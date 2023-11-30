# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]
# We have to use a cloudformation stack here because the provider has a bug in it
# Ref: https://github.com/hashicorp/terraform-provider-aws/issues/34199

resource "aws_cloudformation_stack" "notification_joined" {
  name              = "notifications-joined"
  notification_arns = ["arn:aws:sns:ca-central-1:${var.account_id}:aws-controltower-SecurityNotifications"]

  template_body = jsonencode({

    Resources = {
      notificationsJoined = {
        Type = "AWS::QuickSight::DataSet"
        Properties = {
          AwsAccountId = var.account_id
          DataSetId    = "notifications_joined"
          Name         = "Notifications joined"
          Permissions = [
            {
              Actions = [
                "quicksight:DescribeDataSet",
                "quicksight:DescribeDataSetPermissions",
                "quicksight:DescribeIngestion",
                "quicksight:ListIngestions",
                "quicksight:PassDataSet"
              ],
              Principal = aws_quicksight_group.dataset_viewer.arn
            },
            {
              Actions = [
                "quicksight:DescribeDataSet",
                "quicksight:DescribeDataSetPermissions",
                "quicksight:DescribeIngestion",
                "quicksight:ListIngestions",
                "quicksight:PassDataSet",
                "quicksight:DeleteDataSet",
                "quicksight:UpdateDataSet",
                "quicksight:UpdateDataSetPermissions",
                "quicksight:CreateIngestion",
                "quicksight:CancelIngestion"
              ],
              Principal = aws_quicksight_group.dataset_owner.arn
            }
          ],
          LogicalTableMap = {

            nj-notifications-services-templates = {
              Alias = "nj-notifications-services-templates",
              DataTransforms = [
                {
                  ProjectOperation = {
                    ProjectedColumns = [
                      "id",
                      "job_id",
                      "job_row_number",
                      "service_id",
                      "template_id",
                      "template_version",
                      "api_key_id",
                      "key_type",
                      "notification_type",
                      "created_at",
                      "sent_at",
                      "sent_by",
                      "updated_at",
                      "billable_units",
                      "notification_status",
                      "queue_name",
                      "feedback_type",
                      "feedback_subtype",
                      "service_active",
                      "service_count_as_live",
                      "service_go_live_at",
                      "service_name",
                      "service_message_limit",
                      "service_rate_limit",
                      "service_sms_daily_limit",
                      "template_name",
                      "template_created_at",
                      "template_updated_at"
                    ]
                  }
                }
              ],
              Source = {
                JoinInstruction = {
                  LeftOperand  = "nj-notifications-services",
                  RightOperand = "nj-templates",
                  Type         = "INNER",
                  OnClause     = "{template_id} = {id[Templates]}"
                }
              }
            },

            nj-notifications-services = {
              Alias = "nj-notifications-services",
              DataTransforms = [
                {
                  ProjectOperation = {
                    ProjectedColumns = [
                      "id",
                      "job_id",
                      "job_row_number",
                      "service_id",
                      "template_id",
                      "template_version",
                      "api_key_id",
                      "key_type",
                      "notification_type",
                      "created_at",
                      "sent_at",
                      "sent_by",
                      "updated_at",
                      "billable_units",
                      "notification_status",
                      "queue_name",
                      "feedback_type",
                      "feedback_subtype",
                      "service_active",
                      "service_count_as_live",
                      "service_go_live_at",
                      "service_name",
                      "service_message_limit",
                      "service_rate_limit",
                      "service_sms_daily_limit"
                    ]
                  }
                }
              ],
              Source = {
                JoinInstruction = {
                  LeftOperand  = "nj-notifications",
                  RightOperand = "nj-services",
                  Type         = "INNER",
                  OnClause     = "{service_id} = {id[Services]}"
                }
              }
            },

            nj-notifications = {
              Alias = "nj-notifications",
              Source = {
                DataSetArn = aws_quicksight_data_set.notifications.arn
              }
            },

            nj-services = {
              Alias = "nj-services",
              DataTransforms = [
                {
                  RenameColumnOperation = {
                    ColumnName    = "id",
                    NewColumnName = "id[Services]"
                  }
                },
                {
                  RenameColumnOperation = {
                    ColumnName    = "updated_at",
                    NewColumnName = "service_updated_at"
                  }
                },
                {
                  RenameColumnOperation = {
                    ColumnName    = "created_at",
                    NewColumnName = "service_created_at"
                  }
                },
                {
                  RenameColumnOperation = {
                    ColumnName    = "active",
                    NewColumnName = "service_active"
                  }
                },
                {
                  RenameColumnOperation = {
                    ColumnName    = "count_as_live",
                    NewColumnName = "service_count_as_live"
                  }
                },
                {
                  RenameColumnOperation = {
                    ColumnName    = "go_live_at",
                    NewColumnName = "service_go_live_at"
                  }
                },
                {
                  RenameColumnOperation = {
                    ColumnName    = "name",
                    NewColumnName = "service_name"
                  }
                },
                {
                  RenameColumnOperation = {
                    ColumnName    = "message_limit",
                    NewColumnName = "service_message_limit"
                  }
                },
                {
                  RenameColumnOperation = {
                    ColumnName    = "rate_limit",
                    NewColumnName = "service_rate_limit"
                  }
                },
                {
                  RenameColumnOperation = {
                    ColumnName    = "sms_daily_limit",
                    NewColumnName = "service_sms_daily_limit"
                  }
                }
              ],
              Source = {
                DataSetArn = aws_quicksight_data_set.services.arn
              }
            }

            nj-templates = {
              Alias = "nj-templates",
              DataTransforms = [
                {
                  RenameColumnOperation = {
                    ColumnName    = "id",
                    NewColumnName = "id[Templates]"
                  }
                },
                {
                  RenameColumnOperation = {
                    ColumnName    = "version",
                    NewColumnName = "version[Templates]"
                  }
                },
                {
                  RenameColumnOperation = {
                    ColumnName    = "service_id",
                    NewColumnName = "service_id[Templates]"
                  }
                },
                {
                  RenameColumnOperation = {
                    ColumnName    = "updated_at",
                    NewColumnName = "template_updated_at"
                  }
                },
                {
                  RenameColumnOperation = {
                    ColumnName    = "created_at",
                    NewColumnName = "template_created_at"
                  }
                },
                {
                  RenameColumnOperation = {
                    ColumnName    = "name",
                    NewColumnName = "template_name"
                  }
                },
              ],
              Source = {
                DataSetArn = aws_quicksight_data_set.templates.arn
              }
            }

          },
          DataSetUsageConfiguration = {
            DisableUseAsDirectQuerySource = false,
            DisableUseAsImportedSource    = false
          },
          ImportMode = "SPICE"

        }
      }
    }
  })
}
