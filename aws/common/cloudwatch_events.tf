resource "aws_cloudwatch_event_rule" "aws_health" {
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
         "EKS",
         "IAM",
         "KMS",
         "LAMBDA",
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
  rule      = aws_cloudwatch_event_rule.aws_health.name
  target_id = "aws_health_sns_warning"
  arn       = aws_sns_topic.notification-canada-ca-alert-warning.arn
}
