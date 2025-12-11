# Step Function to update Athena table locations daily
resource "aws_sfn_state_machine" "athena_update_table_location" {
  name     = "AthenaUpdateTableLocation"
  role_arn = aws_iam_role.step_functions_update_tables_location_role.arn

  # Enable X-Ray tracing
  tracing_configuration {
    enabled = true
  }

  logging_configuration {
    level                  = "ALL" # OFF | ERROR | ALL
    include_execution_data = true
    log_destination        = aws_cloudwatch_log_group.step_functions_logs[0].arn
  }

  definition = jsonencode({
    Comment = "Update multiple Athena tables daily with current UTC date",
    StartAt = "GenerateDatePath",
    States = {
      "GenerateDatePath" = {
        Type = "Pass",
        Result = {
          "current_date.$" = "States.FormatDate(States.Timestamp(), 'yyyy-MM-dd')",
          tables = [
            { name = "notifications", database = "notification_quicksight" },
            { name = "notification_history", database = "notification_quicksight" },
            { name = "organisation", database = "notification_quicksight" },
            { name = "services", database = "notification_quicksight" },
            { name = "templates", database = "notification_quicksight" },
            { name = "template_categories", database = "notification_quicksight" }
          ]
        },
        Next = "UpdateTables"
      },
      "UpdateTables" = {
        Type      = "Map",
        ItemsPath = "$.tables",
        Parameters = {
          "table_name.$"   = "$.name"
          "database.$"     = "$.database"
          "current_date.$" = "$.current_date"
        },
        Iterator = {
          StartAt = "RunAthenaQuery",
          States = {
            "RunAthenaQuery" = {
              Type     = "Task",
              Resource = "arn:aws:states:::athena:startQueryExecution.sync",
              Parameters = {
                "QueryString.$" = "States.Format('ALTER TABLE {}.{} SET LOCATION \"s3://${var.datalake_bucket_name}/platform/gc-notify/notification-canada-ca-production-cluster-{}/database/public.{}/1/\";', $.database, $.table_name, $.current_date, $.table_name)",
                QueryExecutionContext = {
                  "Database.$" = "$.database"
                },
                WorkGroup = "Notification-quicksight"
              },
              End = true
            }
          }
        },
        End = true
      }
    }
  })
}


# # Daily trigger for the Step Function and IAM Role for EventBridge
# resource "aws_cloudwatch_event_rule" "step_function_daily_trigger" {
#   name                = "daily-athena-update-table-location"
#   schedule_expression = "cron(10 5 * * ? *)" # daily at midnight UTC
# }

# resource "aws_cloudwatch_event_target" "trigger_sf" {
#   rule = aws_cloudwatch_event_rule.step_function_daily_trigger.name
#   arn  = aws_sfn_state_machine.athena_update_table_location.arn
# }

# resource "aws_iam_role" "eventbridge_role" {
#   name = "eventbridge-invoke-sfn-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect    = "Allow",
#       Principal = { Service = "events.amazonaws.com" },
#       Action    = "sts:AssumeRole"
#     }]
#   })
# }

# resource "aws_iam_role_policy" "eventbridge_sfn_invoke_policy" {
#   name = "EventBridgeInvokeSFNPolicy"
#   role = aws_iam_role.eventbridge_role.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect   = "Allow",
#       Action   = "states:StartExecution",
#       Resource = aws_sfn_state_machine.athena_update_table_location.arn
#     }]
#   })
# }

# resource "aws_cloudwatch_event_target" "target_with_role" {
#   rule     = aws_cloudwatch_event_rule.step_function_daily_trigger.name
#   arn      = aws_sfn_state_machine.athena_update_table_location.arn
#   role_arn = aws_iam_role.eventbridge_role.arn
# }
