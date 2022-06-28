resource "aws_cloudwatch_query_definition" "api-lambda-errors" {
  name = "API lambda - errors"

  log_group_names = [
    local.api_lambda_log_group
  ]

  query_string = <<QUERY
fields @timestamp, @message, @logStream
| filter @message like /rror/
| sort @timestamp desc
| limit 20
QUERY
}
