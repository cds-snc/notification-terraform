data "aws_iam_policy_document" "notify_admin_pr_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "notify_admin_pr" {
  name               = "notify-admin-pr"
  assume_role_policy = data.aws_iam_policy_document.notify_admin_pr_assume.json
}

data "aws_iam_policy_document" "notify_admin_pr" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${var.account_id}:*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/notify-admin-pr-*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForlayer",
      "ecr:BatchGetImage"
    ]
    resources = [var.notify_admin_ecr_arn]
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
      "arn:aws:ssm:${var.region}:${var.account_id}:parameter/ENVIRONMENT_VARIABLES_ADMIN"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ses:ListIdentities",
      "ses:GetIdentityVerificationAttributes"
    ]
    resources = ["*"]
    sid       = ""
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::notification-canada-ca-${var.env}-csv-upload/*"
    ]
  }
}

resource "aws_iam_policy" "notify_admin_pr" {
  name   = "notify-admin-pr"
  path   = "/"
  policy = data.aws_iam_policy_document.notify_admin_pr.json
}

resource "aws_iam_role_policy_attachment" "notify_admin_pr" {
  role       = aws_iam_role.notify_admin_pr.name
  policy_arn = aws_iam_policy.notify_admin_pr.arn
}

resource "aws_iam_role_policy_attachment" "notify_admin_pr_vpc_access" {
  role       = aws_iam_role.notify_admin_pr.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
