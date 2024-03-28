# valid column types are [STRING INTEGER DECIMAL DATETIME BIT BOOLEAN JSON]
# We have to use a cloudformation stack here because the provider has a bug in it
# Ref: https://github.com/hashicorp/terraform-provider-aws/issues/34199

resource "aws_cloudformation_stack" "sms-usage-notifications" {
  name              = "sms-usage-notifications"
  notification_arns = ["arn:aws:sns:ca-central-1:${var.account_id}:aws-controltower-SecurityNotifications"]

  template_body = jsonencode({

    Resources = {
      smsusageJoined = {
        Type = "AWS::QuickSight::DataSet"
        Properties = {
          AwsAccountId = var.account_id
          DataSetId    = "sms-usage-notifications"
          Name         = "Notifications with SMS pricing"
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

            sms-usage-notifications = {
              Alias = "sms-usage-notifications",
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
                      "notification_reference",
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
                      "organisation_id",
                      "PublishTimeUTC",
                      "MessageId",
                      "MessageType",
                      "DeliveryStatus",
                      "PriceInUSD",
                      "PartNumber",
                      "TotalParts"
                    ]
                  }
                }
              ],
              Source = {
                JoinInstruction = {
                  LeftOperand  = "sms-usage",
                  RightOperand = "notifications",
                  Type         = "LEFT",
                  OnClause     = "{MessageId} = {notification_reference}"
                }
              }
            },

            notifications = {
              Alias = "notifications",
              Source = {
                DataSetArn = aws_quicksight_data_set.notifications.arn
              }
            },

            sms-usage = {
              Alias = "sms-usage",
              Source = {
                DataSetArn = aws_quicksight_data_set.sms_usage.arn
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


resource "aws_quicksight_refresh_schedule" "sms-usage-notifications" {
  data_set_id = "sms-usage-notifications"
  schedule_id = "schedule-sms-usage-notifications"
  depends_on  = [aws_cloudformation_stack.sms-usage-notifications]

  schedule {
    refresh_type = "FULL_REFRESH"

    schedule_frequency {
      interval        = "DAILY"
      time_of_the_day = "07:45"
    }
  }
}
