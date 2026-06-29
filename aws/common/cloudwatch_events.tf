resource "aws_cloudwatch_event_rule" "aws_health" {
  provider    = aws.core_services
  count       = var.cloudwatch_enabled ? 1 : 0
  name        = "aws_health"
  description = "Subscribe to AWS health events"

  event_pattern = <<EOF
{
   "source":[
      "aws.health"
   ],
   "detail-type":[
      "AWS Health Event"
   ],
   "detail":{
      "service":[
         "ACM",
         "CLOUDFRONT",
         "CLOUDWATCH",
         "EC2",
         "ECR",
         "EKS",
         "ELASTICACHE",
         "IAM",
         "KMS",
         "LAMBDA",
         "PINPOINT",
         "RDS",
         "ROUTE53",
         "SES",
         "SNS",
         "SQS",
         "WAF"
      ]
   }
}
EOF
}

resource "aws_cloudwatch_event_target" "aws_health_sns_warning" {
  provider  = aws.core_services
  count     = var.cloudwatch_enabled ? 1 : 0
  rule      = aws_cloudwatch_event_rule.aws_health[0].name
  target_id = "aws_health_sns_warning"
  arn       = aws_sns_topic.notification-canada-ca-alert-general.arn
}


# EventBridge API destination rules - forwards GuardDuty scan verdicts to API
resource "aws_cloudwatch_event_connection" "guardduty_scan_verdict_callback" {
  count    = var.cloudwatch_enabled && var.enable_guardduty_scan_api_destination ? 1 : 0
  provider = aws.core_services

  name               = "guardduty-scan-verdict-callback-${var.env}"
  description        = "Connection for GuardDuty scan verdict callback API destination"
  authorization_type = "API_KEY"

  auth_parameters {
    api_key {
      key   = "X-Scan-Callback-Token"
      value = var.manifest_scan_verdict_callback_token
    }
  }
}

resource "aws_cloudwatch_event_api_destination" "guardduty_scan_verdict_callback" {
  count    = var.cloudwatch_enabled && var.enable_guardduty_scan_api_destination ? 1 : 0
  provider = aws.core_services

  name                             = "guardduty-scan-verdict-callback-${var.env}"
  description                      = "GuardDuty scan verdict callback endpoint"
  invocation_endpoint              = var.scan_verdict_callback_url
  http_method                      = "POST"
  invocation_rate_limit_per_second = var.scan_verdict_api_destination_rate_limit_per_second
  connection_arn                   = aws_cloudwatch_event_connection.guardduty_scan_verdict_callback[0].arn
}

resource "aws_cloudwatch_event_rule" "guardduty_scan_verdict" {
  count    = var.cloudwatch_enabled && var.enable_guardduty_scan_api_destination ? 1 : 0
  provider = aws.core_services

  name        = "guardduty_scan_verdict_${var.env}"
  description = "Route GuardDuty malware scan result events for document-download scan bucket"

  event_pattern = <<EOF
{
  "source": ["aws.guardduty"],
  "detail-type": ["GuardDuty Malware Protection Object Scan Result"],
  "account": ["${var.account_id}"],
  "region": ["${var.region}"],
  "detail": {
    "s3ObjectDetails": {
      "bucketName": ["notification-canada-ca-${var.env}-document-download-scan-files"],
      "objectKey": [{"prefix": "template/"}]
    }
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "guardduty_scan_verdict_api_destination" {
  count    = var.cloudwatch_enabled && var.enable_guardduty_scan_api_destination ? 1 : 0
  provider = aws.core_services

  rule      = aws_cloudwatch_event_rule.guardduty_scan_verdict[0].name
  target_id = "guardduty-scan-verdict-api-destination"
  arn       = aws_cloudwatch_event_api_destination.guardduty_scan_verdict_callback[0].arn
  role_arn  = aws_iam_role.eventbridge_invoke_scan_verdict_api_destination[0].arn

  retry_policy {
    maximum_event_age_in_seconds = var.scan_verdict_event_retry_max_age_seconds
    maximum_retry_attempts       = var.scan_verdict_event_retry_max_attempts
  }

  input_transformer {
    input_paths = {
      event_id           = "$.id"
      event_time         = "$.time"
      account            = "$.account"
      region             = "$.region"
      bucket_name        = "$.detail.s3ObjectDetails.bucketName"
      object_key         = "$.detail.s3ObjectDetails.objectKey"
      scan_status        = "$.detail.scanStatus"
      scan_result_status = "$.detail.scanResultDetails.scanResultStatus"
    }

    input_template = <<EOF
{
  "event_id": <event_id>,
  "event_time": <event_time>,
  "account": <account>,
  "region": <region>,
  "bucket_name": <bucket_name>,
  "object_key": <object_key>,
  "scan_status": <scan_status>,
  "scan_result_status": <scan_result_status>
}
EOF
  }
}
