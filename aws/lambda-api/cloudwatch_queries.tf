resource "aws_cloudwatch_query_definition" "50X-errors" {
  name = "API lambda - 50X errors"

  log_group_names = [
    local.api_lambda_log_group
  ]

  query_string = <<QUERY
fields @timestamp, @message, @logStream
| filter @message like /HTTP\/\d+\.\d+\\" 50\d/
| sort @timestamp desc
| limit 20
QUERY
}

