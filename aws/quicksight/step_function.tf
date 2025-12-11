# IAM Role and Policy for Step Functions to update Athena table locations
resource "aws_iam_role" "step_functions_update_tables_location_role" {
  name = "step-functions-update-tables-location-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "states.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "step_functions_update_tables_location_policy" {
  name        = "StepFunctionsUpdateTablesLocationPolicy"
  description = "Policy to allow Step Functions to run Athena queries to update table locations"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "athena:StartQueryExecution",
          "athena:GetQueryExecution",
          "athena:GetQueryResults"
        ],
        Resource = "arn:aws:athena:${var.region}:${var.account_id}:workgroup/*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::notification-canada-ca-${var.env}-athena",
          "arn:aws:s3:::notification-canada-ca-${var.env}-athena/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "glue:GetDatabase",
          "glue:GetTable",
          "glue:UpdateTable"
        ],
        Resource = [
          "arn:aws:glue:${var.region}:${var.account_id}:database/notification_quicksight",
          "arn:aws:glue:${var.region}:${var.account_id}:table/notification_quicksight/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/stepfunctions/${aws_sfn_state_machine.athena_update_table_location.name}:*"
      },
      {
        Effect = "Allow",
        Action = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords"
        ],
        Resource = "arn:aws:states:${var.region}:${var.account_id}:stateMachine:${aws_sfn_state_machine.athena_update_table_location.name}"
      }


    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_sf_policy" {
  role       = aws_iam_role.step_functions_update_tables_location_role.name
  policy_arn = aws_iam_policy.step_functions_update_tables_location_policy.arn
}


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
    log_destination        = aws_cloudwatch_log_group.step_functions_logs.arn
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
