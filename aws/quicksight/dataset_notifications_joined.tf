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

          PhysicalTableMap = {
            nj-notifications-physical = {
              RelationalTable = {
                DataSourceArn = aws_quicksight_data_source.rds.arn
                # Catalog =  "",
                Name = "notifications"
                InputColumns = [
                  {
                    Name = "id",
                    Type = "STRING"
                  },
                  {
                    Name = "to",
                    Type = "STRING"
                  },
                  {
                    Name = "job_id",
                    Type = "STRING"
                  },
                  {
                    Name = "service_id",
                    Type = "STRING"
                  },
                  {
                    Name = "template_id",
                    Type = "STRING"
                  },
                  {
                    Name = "created_at",
                    Type = "DATETIME"
                  },
                  {
                    Name = "sent_at",
                    Type = "DATETIME"
                  },
                  {
                    Name = "sent_by",
                    Type = "STRING"
                  },
                  {
                    Name = "updated_at",
                    Type = "DATETIME"
                  },
                  {
                    Name = "template_version",
                    Type = "INTEGER"
                  },
                  {
                    Name = "api_key_id",
                    Type = "STRING"
                  },
                  {
                    Name = "key_type",
                    Type = "STRING"
                  },
                  {
                    Name = "notification_type",
                    Type = "STRING"
                  },
                  {
                    Name = "notification_status",
                    Type = "STRING"
                  },
                  {
                    Name = "queue_name",
                    Type = "STRING"
                  }
                ]
              }
            }
          }

          LogicalTableMap = {

            nj-notifications-services-org-templates = {
              Alias = "nj-notifications-services-org-templates",
              DataTransforms = [
                {
                  ProjectOperation = {
                    ProjectedColumns = [
                      "id",
                      "created_at",
                      "sent_at",
                      "updated_at",
                      "job_id",
                      "api_key_id",
                      "key_type",
                      "notification_type",
                      "notification_status",
                      "queue_name",
                      "service_id",
                      "service_active",
                      "service_count_as_live",
                      "service_go_live_at",
                      "service_name",
                      "service_message_limit",
                      "service_rate_limit",
                      "service_sms_daily_limit",
                      "template_id",
                      "template_version",
                      "template_name",
                      "template_created_at",
                      "template_updated_at",
                      "org_name",
                      "org_id"
                    ]
                  }
                }
              ],
              Source = {
                JoinInstruction = {
                  LeftOperand  = "nj-notifications-services-org",
                  RightOperand = "nj-templates",
                  Type         = "LEFT",
                  OnClause     = "{template_id} = {id[Templates]}"
                }
              }
            },

            nj-notifications-services-org = {
              Alias = "nj-notifications-services-org",
              Source = {
                JoinInstruction = {
                  LeftOperand  = "nj-notifications-services",
                  RightOperand = "nj-organisation",
                  Type         = "LEFT",
                  OnClause     = "{organisation_id} = {org_id}"
                }
              }
            },

            nj-notifications-services = {
              Alias = "nj-notifications-services",
              Source = {
                JoinInstruction = {
                  LeftOperand  = "nj-notifications",
                  RightOperand = "nj-services",
                  Type         = "LEFT",
                  OnClause     = "{service_id} = {id[Services]}"
                }
              }
            },

            nj-notifications = {
              Alias = "nj-notifications",
              Source = {
                PhysicalTableId = "nj-notifications-physical"
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

            nj-organisation = {
              Alias = "nj-organisation",
              DataTransforms = [
                {
                  RenameColumnOperation = {
                    ColumnName    = "id",
                    NewColumnName = "org_id"
                  }
                },
                {
                  RenameColumnOperation = {
                    ColumnName    = "created_at",
                    NewColumnName = "org_created_at"
                  }
                },
                {
                  RenameColumnOperation = {
                    ColumnName    = "updated_at",
                    NewColumnName = "org_updated_at"
                  }
                },
                {
                  RenameColumnOperation = {
                    ColumnName    = "name",
                    NewColumnName = "org_name"
                  }
                },
              ],
              Source = {
                DataSetArn = aws_quicksight_data_set.organisation.arn
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
