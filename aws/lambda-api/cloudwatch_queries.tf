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
  name = "API Gateway / 504 timeouts grouped by hour"

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
  name  = "API Gateway / Response Code Counts"

  log_group_names = [
    local.api_gateway_log_group
  ]

  query_string = <<QUERY
fields @timestamp, @message, @logStream, status
| stats count(*) by status
QUERY
}

resource "aws_cloudwatch_query_definition" "api_gateway_count_requests_by_minute" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "API Gateway / Requests By Minute"

  log_group_names = [
    local.api_gateway_log_group
  ]

  query_string = <<QUERY
fields @timestamp, @message, @logStream, @log, status, httpMethod
| sort @timestamp desc
| filter ip like /8.8.8.8/
| stats (count(*)) by httpmethod, bin(1m) as minute
| order by minute asc
| limit 100
QUERY
}

resource "aws_cloudwatch_query_definition" "get-trace-by-notification-id" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "API / Get Trace By Notification ID"

  log_group_names = [
    local.api_lambda_log_group,
    "API-Gateway-Execution-Logs_71oj6jax35"
  ]

  query_string = <<QUERY
fields @timestamp, @message, @logStream
| filter @message like /d9cc47e6-b1a3-4c83-8d3c-ab40874307b1/
| filter @message like 'X-Amzn-Trace-Id'
| parse "\"X-Amzn-Trace-Id\": [\"*\"]" as @trace_id
| sort @timestamp asc
| limit 100
QUERY
}

resource "aws_cloudwatch_query_definition" "api-sending-times-aggregate" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "API / API send times aggregate"

  log_group_names = [
    local.api_lambda_log_group
  ]

  query_string = <<QUERY
fields @timestamp, @message, @logStream
| filter @message like /time_taken/ and @message like /Batch saving/
| parse @message "time_taken: *ms" as duration
| parse @message "full_path: '/v2/notifications/*'" as send_type
| parse @message "template_id: '*'" as template_id
| sort @timestamp desc
| stats 
    count(*) as total_sends,
    sum(if(duration <= 400, 1, 0)) as requests_under_400ms,
    sum(if(duration > 400 and duration <= 1000, 1, 0)) as requests_under_1s,
    sum(if(duration > 1000, 1, 0)) as requests_over_1s,
    (sum(if(duration <= 400, 1, 0)) * 100.0 / count(*)) as percent_under_400ms,
    (sum(if(duration > 400 and duration <= 1000, 1, 0)) * 100.0 / count(*)) as percent_under_1s, 
    (sum(if(duration > 1000, 1, 0)) * 100.0 / count(*)) as percent_over_1s
| limit 20
QUERY
}

resource "aws_cloudwatch_query_definition" "api-slowest-sends" {
  count = var.cloudwatch_enabled ? 1 : 0
  name  = "API / API slowest sends"

  log_group_names = [
    local.api_lambda_log_group
  ]

  query_string = <<QUERY
fields @timestamp, @message, @logStream
| filter @message like /time_taken/ and @message like /Batch saving/
| parse @message "time_taken: *ms" as duration
| parse @message "full_path: '/v2/notifications/*'" as send_type
| parse @message "template_id: '*'" as template_id
| sort duration desc
| limit 20
QUERY
}
