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

resource "aws_cloudwatch_query_definition" "services-over-daily-rate-limit" {
  name = "Services going over daily rate limits"

  log_group_names = [
    local.api_lambda_log_group
  ]

  query_string = <<QUERY
fields @timestamp, message, @logStream
| filter strcontains(message, 'has been rate limited')
| sort @timestamp desc
| limit 20
QUERY
}
