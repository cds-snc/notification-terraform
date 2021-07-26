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

###
# IAM role for S3 bulk send
###
resource "aws_iam_user" "bulk_send" {
  name = "bulk-send"
}

resource "aws_iam_access_key" "bulk_send" {
  user = aws_iam_user.bulk_send.name
}

resource "aws_iam_user_policy" "write_s3_bulk_send" {
  name = "WriteS3BulkSend"
  user = aws_iam_user.bulk_send.name

  policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Sid":"ListObjectsInBucket",
         "Effect":"Allow",
         "Action":[
            "s3:ListBucket"
         ],
         "Resource":[
            "${aws_s3_bucket.bulk_send.arn}"
         ]
      },
      {
         "Sid":"AllObjectActions",
         "Effect":"Allow",
         "Action":"s3:*Object",
         "Resource":[
            "${aws_s3_bucket.bulk_send.arn}/*"
         ]
      }
   ]
}
EOF
}

###
# IAM role for Continuous guardrail scanning
# https://github.com/cds-snc/continuous-guardrail-scanning
# Group + User + Credentials + Policy
###
resource "aws_iam_group" "inspec" {
  name = "inspec"
}

resource "aws_iam_user" "inspec-scanner" {
  name = "inspec-scanner"
}

resource "aws_iam_user_group_membership" "inspec-scanner-to-inspec" {
  user = aws_iam_user.inspec-scanner.name

  groups = [
    aws_iam_group.inspec.name
  ]
}

resource "aws_iam_access_key" "inspec-scanner" {
  user = aws_iam_user.inspec-scanner.name
}

resource "aws_iam_group_policy" "inspec_cloud_guard_rails" {
  name  = "InspecCloudGuardRails"
  group = aws_iam_group.inspec.name

  policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Sid":"InspecCloudGuardRails",
         "Effect":"Allow",
         "Action":[
            "cloudtrail:DescribeTrails",
            "ec2:DescribeInstances",
            "ec2:DescribeRegions",
            "ec2:DescribeVolumes",
            "iam:GetAccountSummary",
            "iam:GetInstanceProfile",
            "iam:GetLoginProfile",
            "iam:ListAccessKeys",
            "iam:ListAttachedUserPolicies",
            "iam:ListMFADevices",
            "iam:ListUserPolicies",
            "iam:ListUsers",
            "iam:ListVirtualMFADevices",
            "rds:DescribeDBClusters",
            "rds:DescribeDBInstances",
            "s3:GetBucketLocation",
            "s3:GetBucketTagging",
            "s3:GetEncryptionConfiguration",
            "s3:ListAllMyBuckets",
            "SNS:ListTopics"
         ],
         "Resource":"*"
      }
   ]
}
EOF
}

resource "aws_iam_role" "rds-proxy-to-secrets-role" {
  name = "rds-proxy-to-secrets-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "rds.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "rds-proxy-to-secrets-policy" {
  name = "rds-proxy-to-secrets-policy"
  role = aws_iam_role.rds-proxy-to-secrets-role.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "secretsmanager:GetSecretValue",
            "Resource": [
                "arn:aws:secretsmanager:us-east-2:${var.account_id}:secret:secret_name_1"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "kms:Decrypt",
            "Resource": "arn:aws:kms:us-east-2:${var.account_id}:key/key_id",
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": "secretsmanager.us-east-2.amazonaws.com"
                }
            }
        }
    ]
}
POLICY
}
