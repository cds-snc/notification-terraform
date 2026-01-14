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
    log_destination        = "${aws_cloudwatch_log_group.step_functions_logs[0].arn}:*"
  }

  definition = jsonencode({
    Comment = "Update multiple Athena tables daily with current UTC date",
    StartAt = "GenerateDatePath",
    States = {
      "GenerateDatePath" = {
        Type = "Pass",
        Parameters = {
          "current_date.$" : "States.Format('{}-{}-{}', States.ArrayGetItem(States.StringSplit($$.State.EnteredTime, '-,T'), 0), States.ArrayGetItem(States.StringSplit($$.State.EnteredTime, '-,T'), 1), States.ArrayGetItem(States.StringSplit($$.State.EnteredTime, '-,T'), 2))",
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
          "table_name.$" : "$$.Map.Item.Value.name",
          "database.$" : "$$.Map.Item.Value.database",
          "current_date.$" : "$.current_date"
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
                WorkGroup = "Notification_quicksight"
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

# Daily trigger for the Step Function and IAM Role for EventBridge
resource "aws_cloudwatch_event_rule" "step_function_daily_trigger" {
  count = var.env == "production" ? 1 : 0

  name                = "daily-athena-update-table-location"
  description         = "Daily trigger to update Athena table locations"
  schedule_expression = "cron(10 5 * * ? *)" # daily at 05:10 UTC
}

resource "aws_iam_role" "eventbridge_role" {
  count = var.env == "production" ? 1 : 0

  name = "eventbridge-invoke-sfn-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "events.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "eventbridge_sfn_invoke_policy" {
  count = var.env == "production" ? 1 : 0

  name = "EventBridgeInvokeSFNPolicy"
  role = aws_iam_role.eventbridge_role[0].id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "states:StartExecution",
      Resource = aws_sfn_state_machine.athena_update_table_location.arn
    }]
  })
}

resource "aws_cloudwatch_event_target" "target_with_role" {
  count = var.env == "production" ? 1 : 0

  rule     = aws_cloudwatch_event_rule.step_function_daily_trigger[0].name
  arn      = aws_sfn_state_machine.athena_update_table_location.arn
  role_arn = aws_iam_role.eventbridge_role[0].arn
}
