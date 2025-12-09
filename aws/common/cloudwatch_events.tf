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
