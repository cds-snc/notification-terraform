resource "aws_cloudwatch_event_rule" "aws_health" {
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
  count     = var.cloudwatch_enabled ? 1 : 0
  rule      = aws_cloudwatch_event_rule.aws_health[0].name
  target_id = "aws_health_sns_warning"
  arn       = aws_sns_topic.notification-canada-ca-alert-general.arn
}

###
# SES Domain Identity Issues (DKIM/DNS Record Failures)
# Captures AWS Health events specifically for SES reputation and identity issues.
# This rule monitors for AWS notifications about SES problems that may indicate
# DNS/DKIM record issues, such as when client domains remove or modify required records.
# Related documentation: docs/dnsDkimAlerts.md
###

resource "aws_cloudwatch_event_rule" "ses_reputation_identity_issues" {
  count       = var.cloudwatch_enabled ? 1 : 0
  name        = "ses-reputation-identity-issues"
  description = "Alert on SES reputation and domain identity issues including DNS/DKIM failures"

  event_pattern = jsonencode({
    source      = ["aws.health"]
    detail-type = ["AWS Health Event"]
    detail = {
      service = ["SES"]
      eventTypeCategory = [
        "issue",
        "accountNotification"
      ]
    }
  })
}

resource "aws_cloudwatch_event_target" "ses_reputation_identity_issues_warning" {
  count     = var.cloudwatch_enabled ? 1 : 0
  rule      = aws_cloudwatch_event_rule.ses_reputation_identity_issues[0].name
  target_id = "ses_reputation_identity_issues_warning"
  arn       = aws_sns_topic.notification-canada-ca-alert-warning.arn
}
