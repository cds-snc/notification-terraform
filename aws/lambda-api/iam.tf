data "aws_iam_policy_document" "service_principal" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "api" {
  name               = "notify-api"
  assume_role_policy = data.aws_iam_policy_document.service_principal.json
}

data "aws_iam_policy" "lambda_insights" {
  name = "CloudWatchLambdaInsightsExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "lambda_insights" {
  role       = aws_iam_role.api.name
  policy_arn = data.aws_iam_policy.lambda_insights.arn
}

data "aws_iam_policy_document" "api_policies" {

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [aws_cloudwatch_log_group.api_gateway_log_group.arn]
  }

  statement {
   
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForlayer",
      "ecr:BatchGetImage"
    ]
    resources = [aws_ecr_repository.api-lambda.arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = ["${var.csv_upload_bucket_arn}/*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "sqs:*",                           # need to send stuff to celery workers
      "sns:Publish",                     # probably dont need 
      "securityhub:BatchImportFindings", # what is this for?
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:DescribeParameters",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
    ]
    resources = [
      "arn:aws:ssm:${var.region}:${var.account_id}:parameter/ENVIRONMENT_VARIABLES"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    resources = [
      aws_secretsmanager_secret_version.new-relic-license-key.arn
    ]
  }
}

resource "aws_iam_policy" "api" {
  name   = "notify-api"
  path   = "/"
  policy = data.aws_iam_policy_document.api_policies.json
}

resource "aws_iam_role_policy_attachment" "api" {
  role       = aws_iam_role.api.name
  policy_arn = aws_iam_policy.api.arn
}

# Use AWS managed IAM policy
####
# Provides minimum permissions for a Lambda function to execute while
# accessing a resource within a VPC - create, describe, delete network
# interfaces and write permissions to CloudWatch Logs.
####
resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
  role       = aws_iam_role.api.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

#### VAULT

# Vault Client (Lambda function) IAM Config
resource "aws_iam_instance_profile" "lambda" {
  name = "${var.env}-lambda-instance-profile"
  role = aws_iam_role.api.name
}

## Vault Server IAM Config
resource "aws_iam_instance_profile" "vault-server" {
  name = "${var.env}-vault-server-instance-profile"
  role = aws_iam_role.vault-server.name
}

resource "aws_iam_role" "vault-server" {
  name               = "${var.env}-vault-server-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_ec2.json
}

resource "aws_iam_role_policy" "vault-server" {
  name   = "${var.env}-vault-server-role-policy"
  role   = aws_iam_role.vault-server.id
  policy = data.aws_iam_policy_document.vault-server.json
}
data "aws_iam_policy_document" "assume_role_ec2" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "vault-server" {
  statement {
    sid    = "ConsulAutoJoin"
    effect = "Allow"

    actions = ["ec2:DescribeInstances"]

    resources = ["*"]
  }

  statement {
    sid    = "VaultAWSAuthMethod"
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "iam:GetInstanceProfile",
      "iam:GetUser",
      "iam:GetRole",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "VaultKMSUnseal"
    effect = "Allow"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
    ]

    resources = ["*"]
  }
}
