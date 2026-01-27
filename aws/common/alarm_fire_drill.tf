# Fire drill Lambda function to test Slack alert notifications
# This Lambda publishes test messages to the WARNING, CRITICAL, and OK SNS topics
# to verify the alerting pipeline is functioning correctly.
#
# VERIFICATION:
# A separate GitHub Action (runs independently of AWS) will check Slack to verify
# the fire drill messages actually appeared. This ensures monitoring even if AWS
# infrastructure fails or Slack integration breaks.
#
# To manually invoke for testing:
# aws lambda invoke --function-name alarm-fire-drill response.json

data "archive_file" "alarm_fire_drill_lambda" {
  count       = var.cloudwatch_enabled && contains(["dev", "staging", "production"], var.env) ? 1 : 0
  type        = "zip"
  output_path = "/tmp/alarm_fire_drill.zip"

  source {
    content  = <<-EOF
import json
import boto3
import os
from datetime import datetime

sns = boto3.client('sns')

def lambda_handler(event, context):
    warning_topic = os.environ['WARNING_TOPIC_ARN']
    critical_topic = os.environ['CRITICAL_TOPIC_ARN']
    ok_topic = os.environ['OK_TOPIC_ARN']
    environment = os.environ['ENVIRONMENT']
    timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S UTC')
    run_id = context.aws_request_id
    results = {}
    
    print('Fire drill run ID: ' + run_id)
    
    # Test WARNING alert
    try:
        warning_message = {
            'AlarmName': 'fire-drill-warning-test',
            'AlarmDescription': 'Fire drill test of WARNING alert path at ' + timestamp,
            'AWSAccountId': '123456789',
            'NewStateValue': 'ALARM',
            'NewStateReason': 'Fire drill test - verifying warning notification path. Run ID: ' + run_id,
            'StateChangeTime': timestamp,
            'Region': os.environ.get('AWS_REGION', 'ca-central-1'),
            'AlarmArn': 'arn:aws:cloudwatch:ca-central-1:123456789:alarm:fire-drill-warning-test',
            'OldStateValue': 'OK'
        }
        warning_response = sns.publish(
            TopicArn=warning_topic,
            Subject='ALARM: "fire-drill-warning-test" in ca-central-1',
            Message=json.dumps({'default': json.dumps(warning_message)}),
            MessageStructure='json'
        )
        results['warning'] = 'SUCCESS'
        print('Published WARNING: ' + warning_response['MessageId'])
    except Exception as e:
        results['warning'] = 'FAILED: ' + str(e)
        print('WARNING failed: ' + str(e))
    
    # Test CRITICAL alert
    try:
        critical_message = {
            'AlarmName': 'fire-drill-critical-test',
            'AlarmDescription': 'Fire drill test of CRITICAL alert path at ' + timestamp,
            'AWSAccountId': '123456789',
            'NewStateValue': 'ALARM',
            'NewStateReason': 'Fire drill test - verifying critical notification path. Run ID: ' + run_id,
            'StateChangeTime': timestamp,
            'Region': os.environ.get('AWS_REGION', 'ca-central-1'),
            'AlarmArn': 'arn:aws:cloudwatch:ca-central-1:123456789:alarm:fire-drill-critical-test',
            'OldStateValue': 'OK'
        }
        critical_response = sns.publish(
            TopicArn=critical_topic,
            Subject='ALARM: "fire-drill-critical-test" in ca-central-1',
            Message=json.dumps({'default': json.dumps(critical_message)}),
            MessageStructure='json'
        )
        results['critical'] = 'SUCCESS'
        print('Published CRITICAL: ' + critical_response['MessageId'])
    except Exception as e:
        results['critical'] = 'FAILED: ' + str(e)
        print('CRITICAL failed: ' + str(e))
    
    # Test OK alert
    try:
        ok_message = {
            'AlarmName': 'fire-drill-ok-test',
            'AlarmDescription': 'Fire drill test of OK alert path at ' + timestamp,
            'AWSAccountId': '123456789',
            'NewStateValue': 'OK',
            'NewStateReason': 'Fire drill test - verifying ok/recovery notification path. Run ID: ' + run_id,
            'StateChangeTime': timestamp,
            'Region': os.environ.get('AWS_REGION', 'ca-central-1'),
            'AlarmArn': 'arn:aws:cloudwatch:ca-central-1:123456789:alarm:fire-drill-ok-test',
            'OldStateValue': 'ALARM'
        }
        ok_response = sns.publish(
            TopicArn=ok_topic,
            Subject='OK: "fire-drill-ok-test" in ca-central-1',
            Message=json.dumps({'default': json.dumps(ok_message)}),
            MessageStructure='json'
        )
        results['ok'] = 'SUCCESS'
        print('Published OK: ' + ok_response['MessageId'])
    except Exception as e:
        results['ok'] = 'FAILED: ' + str(e)
        print('OK failed: ' + str(e))
    
    # Return results (GitHub Action will verify messages in Slack)
    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'Fire drill completed - verification will be done by GitHub Action',
            'environment': environment,
            'timestamp': timestamp,
            'run_id': run_id,
            'results': results
        })
    }
EOF
    filename = "lambda_function.py"
  }
}

resource "aws_lambda_function" "alarm_fire_drill" {
  count            = var.cloudwatch_enabled && contains(["dev", "staging", "production"], var.env) ? 1 : 0
  filename         = data.archive_file.alarm_fire_drill_lambda[0].output_path
  function_name    = "alarm-fire-drill"
  role             = aws_iam_role.alarm_fire_drill[0].arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.alarm_fire_drill_lambda[0].output_base64sha256
  runtime          = "python3.11"
  timeout          = 30

  tracing_config {
    mode = "Active"
  }

  #checkov:skip=CKV_AWS_272:Code signing not required for fire drill Lambda

  environment {
    variables = {
      WARNING_TOPIC_ARN  = aws_sns_topic.notification-canada-ca-alert-warning.arn
      CRITICAL_TOPIC_ARN = aws_sns_topic.notification-canada-ca-alert-critical.arn
      OK_TOPIC_ARN       = aws_sns_topic.notification-canada-ca-alert-ok.arn
      ENVIRONMENT        = var.env
    }
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_iam_role" "alarm_fire_drill" {
  count = var.cloudwatch_enabled && contains(["dev", "staging", "production"], var.env) ? 1 : 0
  name  = "alarm-fire-drill-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_iam_role_policy" "alarm_fire_drill_sns" {
  count = var.cloudwatch_enabled && contains(["dev", "staging", "production"], var.env) ? 1 : 0
  name  = "alarm-fire-drill-sns-publish"
  role  = aws_iam_role.alarm_fire_drill[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = [
          aws_sns_topic.notification-canada-ca-alert-warning.arn,
          aws_sns_topic.notification-canada-ca-alert-critical.arn,
          aws_sns_topic.notification-canada-ca-alert-ok.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = [
          aws_kms_key.notification-canada-ca.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "alarm_fire_drill_basic" {
  count      = var.cloudwatch_enabled && contains(["dev", "staging", "production"], var.env) ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.alarm_fire_drill[0].name
}

# EventBridge rule to trigger fire drill at 9am ET daily
# Cron format: minute hour day month day-of-week year
# 9am ET = 2pm UTC (during standard time) or 1pm UTC (during daylight saving time)
# Using 2pm UTC to account for Eastern Standard Time
resource "aws_cloudwatch_event_rule" "alarm_fire_drill" {
  count               = var.cloudwatch_enabled && contains(["dev", "staging", "production"], var.env) ? 1 : 0
  name                = "alarm-fire-drill-daily"
  description         = "Trigger alarm fire drill test daily at 9am ET"
  schedule_expression = "cron(0 14 * * ? *)"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_cloudwatch_event_target" "alarm_fire_drill" {
  count = var.cloudwatch_enabled && contains(["dev", "staging", "production"], var.env) ? 1 : 0
  rule  = aws_cloudwatch_event_rule.alarm_fire_drill[0].name
  arn   = aws_lambda_function.alarm_fire_drill[0].arn
}

resource "aws_lambda_permission" "alarm_fire_drill_cloudwatch" {
  count         = var.cloudwatch_enabled && contains(["dev", "staging", "production"], var.env) ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.alarm_fire_drill[0].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.alarm_fire_drill[0].arn
}

resource "aws_cloudwatch_log_group" "alarm_fire_drill" {
  count             = var.cloudwatch_enabled && contains(["dev", "staging", "production"], var.env) ? 1 : 0
  name              = "/aws/lambda/${aws_lambda_function.alarm_fire_drill[0].function_name}"
  retention_in_days = 90

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}
