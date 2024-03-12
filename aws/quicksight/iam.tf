
##### Quicksight connect to RDS

resource "aws_iam_role" "quicksight" {
  name = "quicksight"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "quicksight.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "quicksight-rds" {
  name        = "rds-access"
  description = "Allow access to RDS"
  policy = jsonencode({

    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds-db:connect",
          "rds:Describe*",
          "rds:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds-qs-attach" {
  role       = aws_iam_role.quicksight.name
  policy_arn = aws_iam_policy.quicksight-rds.arn
}

resource "aws_iam_policy" "quicksight-s3-usage" {
  name        = "s3-usage"
  description = "Allow access to S3"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# This should be enough
# From https://us-east-1.console.aws.amazon.com/iam/home?region=ca-central-1#/policies/details/arn%3Aaws%3Aiam%3A%3A239043911459%3Apolicy%2Fservice-role%2FAWSQuickSightS3Policy?section=permissions&view=json

resource "aws_iam_policy" "quicksight-s3-restricted" {
  name        = "s3-usage-restricted"
  description = "Allow access to S3"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "arn:aws:s3:::*"
        },
        {
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::notification-canada-ca-staging-sms-usage-west-2-logs",
                "arn:aws:s3:::notification-canada-ca-staging-sms-usage-logs"
            ]
        },
        {
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::notification-canada-ca-staging-sms-usage-west-2-logs/*",
                "arn:aws:s3:::notification-canada-ca-staging-sms-usage-logs/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3-qs-attach" {
  role       = aws_iam_role.quicksight.name
  policy_arn = aws_iam_policy.quicksight-s3-usage.arn
}
