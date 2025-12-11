
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
          "s3:ListBucketMultipartUploads"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3-qs-attach" {
  role       = aws_iam_role.quicksight.name
  policy_arn = aws_iam_policy.quicksight-s3-usage.arn
}

resource "aws_iam_role" "datalake-reader" {
  name = "datalake-reader-cross-account-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = ["glue.amazonaws.com",
          "athena.amazonaws.com"]
        }
      },
    ]
  })
}

resource "aws_iam_policy" "datalake-reader-s3" {
  name        = "s3-access-cross-account"
  description = "Allow access to S3 in the datalake account"
  policy = jsonencode({

    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${var.datalake_bucket_name}",
          "arn:aws:s3:::${var.datalake_bucket_name}/*"
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "datalake-reader-s3-attach" {
  role       = aws_iam_role.datalake-reader.name
  policy_arn = aws_iam_policy.datalake-reader-s3.arn
}

resource "aws_iam_policy" "quicksight-datalake-s3" {
  name        = "AWSQuickSightDatalakeS3Policy"
  description = "Allow access to S3 in the datalake account"
  policy = jsonencode({

    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${var.datalake_bucket_name}",
          "arn:aws:s3:::${var.datalake_bucket_name}/*"
        ]
      },
      {
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:kms:${var.region}:${var.datalake_account_id}:key/*",
          "arn:aws:kms:${var.region}:${var.account_id}:key/*"
        ]
      },
    ]
  })
}

data "aws_iam_role" "quicksight_service_role" {
  name = "aws-quicksight-service-role-v0"
}

resource "aws_iam_role_policy_attachment" "quicksight-datalake-s3-attach" {
  role       = data.aws_iam_role.quicksight_service_role.name
  policy_arn = aws_iam_policy.quicksight-datalake-s3.arn
}

# IAM Role and Policy for Step Functions to update Athena table locations
resource "aws_iam_role" "step_functions_update_tables_location_role" {
  name = "step-functions-update-tables-location-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "states.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "step_functions_update_tables_location_policy" {
  name        = "StepFunctionsUpdateTablesLocationPolicy"
  description = "Policy to allow Step Functions to run Athena queries to update table locations"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "athena:StartQueryExecution",
          "athena:GetQueryExecution",
          "athena:GetQueryResults"
        ],
        Resource = "arn:aws:athena:${var.region}:${var.account_id}:workgroup/*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::notification-canada-ca-${var.env}-athena",
          "arn:aws:s3:::notification-canada-ca-${var.env}-athena/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "glue:GetDatabase",
          "glue:GetTable",
          "glue:UpdateTable"
        ],
        Resource = [
          "arn:aws:glue:${var.region}:${var.account_id}:database/notification_quicksight",
          "arn:aws:glue:${var.region}:${var.account_id}:table/notification_quicksight/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "${aws_cloudwatch_log_group.step_functions_logs[0].arn}:*"
      },
      {
        Effect = "Allow",
        Action = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords"
        ],
        Resource = "arn:aws:states:${var.region}:${var.account_id}:stateMachine:*"
      }


    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_sf_policy" {
  role       = aws_iam_role.step_functions_update_tables_location_role.name
  policy_arn = aws_iam_policy.step_functions_update_tables_location_policy.arn
}
