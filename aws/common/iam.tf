###
# AWS SNS Cloudwatch IAM role
###

resource "aws_iam_role" "sns-delivery-role" {
  name = "sns-delivery-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}

POLICY
}

resource "aws_iam_role_policy" "sns-delivery-role-policy" {
  name = "sns-delivery-role-policy"
  role = aws_iam_role.sns-delivery-role.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:PutMetricFilter",
        "logs:PutRetentionPolicy"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
POLICY
}

###
# IAM roles for Lambda
###

resource "aws_iam_role" "iam_lambda_to_sqs" {
  name = "iam_lambda_to_sqs"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a Lambda"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_lambda_to_sqs.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_policy" "lambda_sqs_send" {
  name        = "lambda_sqs_send"
  path        = "/"
  description = "IAM policy for sending messages to SQS from Lambda"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "sqs:Get*",
                "sqs:SendMessage"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "lambda_sqs" {
  role       = aws_iam_role.iam_lambda_to_sqs.name
  policy_arn = aws_iam_policy.lambda_sqs_send.arn
}

##
# IAM role for a Kinesis Firehose to write AWS WAF ACL logs to the
# Cloud Based Sensor S3 satellite bucket
##
resource "aws_iam_role" "firehose_waf_logs" {
  name               = "FirehoseWafLogs"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume.json
}

resource "aws_iam_policy" "firehose_waf_logs" {
  name   = "FirehoseWafLogsPolicy"
  path   = "/"
  policy = data.aws_iam_policy_document.firehose_waf_logs.json
}

resource "aws_iam_role_policy_attachment" "firehose_waf_logs" {
  role       = aws_iam_role.firehose_waf_logs.name
  policy_arn = aws_iam_policy.firehose_waf_logs.arn
}

data "aws_iam_policy_document" "firehose_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "firehose_waf_logs" {
  statement {
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${var.cbs_satellite_bucket_name}",
      "arn:aws:s3:::${var.cbs_satellite_bucket_name}/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "iam:CreateServiceLinkedRole"
    ]
    resources = [
      "arn:aws:iam::*:role/aws-service-role/wafv2.amazonaws.com/AWSServiceRoleForWAFV2Logging"
    ]
  }
}

resource "aws_sqs_queue_policy" "allow_sns_publish" {
  queue_url = aws_sqs_queue.ses_receipt_callback_buffer.id
  policy    = data.aws_iam_policy_document.sns_to_sqs.json
}

data "aws_iam_policy_document" "sns_to_sqs" {
  statement {
    sid    = "AllowSNSPublish"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.ses_receipt_callback_buffer.arn]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.notification-canada-ca-ses-callback.arn]
    }
  }
}

# This is required for Karpenter. Older accounts do not have this enabled by default
resource "aws_iam_service_linked_role" "spotInstances" {
  aws_service_name = "spot.amazonaws.com"
}
