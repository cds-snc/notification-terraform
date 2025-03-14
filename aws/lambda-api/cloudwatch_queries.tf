resource "aws_cloudwatch_query_definition" "api-lambda-errors" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "API / API Lambda errors"

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
  name = "API / Services going over daily rate limits"

  log_group_names = [
    local.api_lambda_log_group,
    var.eks_application_log_group
  ]

  query_string = <<QUERY
filter (ispresent(application) or ispresent(kubernetes.host)) and @message like /has been rate limited/
| parse @message /service (?<service>.*?) has been rate limited for (?<limit_type>..........).*/
| stats count(*) by service, limit_type
QUERY
}

resource "aws_cloudwatch_query_definition" "api-gateway-504-timeouts" {
  name = "API Gateway 504 timeouts grouped by hour"

  log_group_names = [
    local.api_gateway_log_group
  ]

  query_string = <<QUERY
fields @timestamp, @message, @logStream, status
| filter status = "504"
| stats count() as error_count by bin(@timestamp, 1h)
| sort @timestamp desc
| limit 1000
QUERY
}

resource "aws_cloudwatch_query_definition" "api_gateway_response_code_counts" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "API Gateway Response Code Counts"

  log_group_names = [
    local.api_gateway_log_group
  ]

  query_string = <<QUERY
fields @timestamp, @message, @logStream, @log
| filter @message like /ea5e8773-c2eb-4523-97f9-25bc3018fbc1/
| sort @timestamp desc
QUERY
}
