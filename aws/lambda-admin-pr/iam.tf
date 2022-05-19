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
    resources = [aws_ecr_repository.notify_admin.arn]
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
