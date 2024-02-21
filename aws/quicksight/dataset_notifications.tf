# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]
# We have to use a cloudformation stack here because the provider has a bug in it
# Ref: https://github.com/hashicorp/terraform-provider-aws/issues/34199

resource "aws_cloudformation_stack" "notifications" {
  name              = "notifications"
  notification_arns = ["arn:aws:sns:ca-central-1:${var.account_id}:aws-controltower-SecurityNotifications"]

  template_body = jsonencode({

    Resources = {
      notificationsJoined = {
        Type = "AWS::QuickSight::DataSet"
        Properties = {
          AwsAccountId = var.account_id
          DataSetId    = "notifications"
          Name         = "Notifications"
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
              CustomSql = {
                DataSourceArn = aws_quicksight_data_source.rds.arn
                Name          = "notifications"

                SqlQuery = <<EOF
                  with notification_data as (
                      select 
                          id as notification_id,
                          created_at as notification_created_at,
                          queue_name as notification_queue_name,
                          sent_at as notification_sent_at,
                          notification_status,
                          notification_type,
                          updated_at notification_updated_at,
                          service_id,
                          template_id,
                          job_id,
                          api_key_id,
                          api_key_type
                      from notifications
                      union
                      select 
                          id as notification_id,
                          created_at as notification_created_at,
                          queue_name as notification_queue_name,
                          sent_at as notification_sent_at,
                          notification_status,
                          notification_type,
                          updated_at notification_updated_at,
                          service_id,
                          template_id,
                          job_id,
                          api_key_id,
                          api_key_type
                      from notification_history
                  ),
                  service_data as (
                      select
                          s.id as service_id,
                          s.active as service_active,
                          count_as_live as service_count_as_live,
                          s.go_live_at as service_go_live_at,
                          s.name as service_name,
                          s.message_limit as service_message_limit,
                          s.rate_limit as service_rate_limit,
                          s.sms_daily_limit as service_sms_daily_limit,
                          o.name as organisation_name,
                          s.organisation_id
                      from services s join organisation o on s.organisation_id = o.id
                  ),
                  template_data as (
                      select
                          id as template_id,
                          created_at as template_created_at,
                          name as template_name,
                          updated_at as template_updated_at,
                          version as template_version
                      from templates
                  ),
                  data_joined as (
                      select
                        notification_id, notification_created_at, notification_sent_at, notification_updated_at, 
                        notification_queue_name, notification_status, notification_type, job_id, api_key_id, api_key_type
                      s.*, t.*
                      from notification_data n 
                          join service_data s on n.service_id = s.service_id
                          join template_data t on n.template_id = t.template_id
                  )
                  select * from data_joined
                EOF
                InputColumns = [
                  {
                    Name = "notification_id",
                    Type = "STRING"
                  },
                  {
                    Name = "notification_created_at",
                    Type = "DATETIME"
                  },
                  {
                    Name = "notification_sent_at",
                    Type = "DATETIME"
                  },
                  {
                    Name = "notification_updated_at",
                    Type = "DATETIME"
                  },
                  {
                    Name = "notification_queue_name",
                    Type = "STRING"
                  },
                  {
                    Name = "notification_status",
                    Type = "STRING"
                  },
                  {
                    Name = "notification_type",
                    Type = "STRING"
                  },
                  {
                    Name = "job_id",
                    Type = "STRING"
                  },
                  {
                    Name = "api_key_id",
                    Type = "STRING"
                  },
                  {
                    Name = "api_key_type",
                    Type = "STRING"
                  },
                  {
                    Name = "service_id",
                    Type = "STRING"
                  },
                  {
                    Name = "service_active",
                    Type = "BIT"
                  },
                  {
                    Name = "service_count_as_live",
                    Type = "BIT"
                  },
                  {
                    Name = "service_go_live_at",
                    Type = "DATETIME"
                  },
                  {
                    Name = "service_name",
                    Type = "STRING"
                  },
                  {
                    Name = "service_message_limit",
                    Type = "INTEGER"
                  },
                  {
                    Name = "service_rate_limit",
                    Type = "INTEGER"
                  },
                  {
                    Name = "service_sms_daily_limit",
                    Type = "INTEGER"
                  },
                  {
                    Name = "organisation_name",
                    Type = "STRING"
                  },
                  {
                    Name = "organisation_id",
                    Type = "STRING"
                  },
                  {
                    Name = "template_id",
                    Type = "STRING"
                  },
                  {
                    Name = "template_created_at",
                    Type = "DATETIME"
                  },
                  {
                    Name = "template_name",
                    Type = "STRING"
                  },
                  {
                    Name = "template_updated_at",
                    Type = "DATETIME"
                  },
                  {
                    Name = "template_version",
                    Type = "INTEGER"
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
                      "notification_id",
                      "notification_created_at",
                      "notification_sent_at",
                      "notification_updated_at",
                      "notification_type",
                      "notification_status",
                      "notification_queue_name",
                      "job_id",
                      "api_key_id",
                      "api_key_type",
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
                      "organisation_name",
                      "organisation_id"
                    ]
                  }
                }
              ],
              Source = {
                PhysicalTableId = "nj-notifications-physical"
              }
            },
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


resource "aws_quicksight_refresh_schedule" "notifications" {
  data_set_id = "notifications"
  schedule_id = "schedule-notifications"
  depends_on  = [aws_cloudformation_stack.notifications]

  schedule {
    refresh_type = "FULL_REFRESH"

    schedule_frequency {
      interval        = "DAILY"
      time_of_the_day = "07:10"
    }
  }
}
