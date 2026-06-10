resource "aws_iam_user" "ecr-user" {
  provider = aws.core_services
  name     = "ecr-user"
}

resource "aws_iam_group_membership" "ecr" {
  provider = aws.core_services
  name     = "ecr-group-membership"
  users = [
    aws_iam_user.ecr-user.name
  ]
  group = aws_iam_group.ecr.name
}

resource "aws_iam_group" "ecr" {
  provider = aws.core_services
  name     = "ecr-api-lambda-group"
}

resource "aws_iam_group_policy_attachment" "ecr" {
  provider   = aws.core_services
  group      = aws_iam_group.ecr.name
  policy_arn = aws_iam_policy.ecr.arn
}

resource "aws_iam_policy" "ecr" {
  provider    = aws.core_services
  name        = "ecr-api-lambda-access"
  description = "Allow push to only api-lambda ECR"
  policy      = data.aws_iam_policy_document.ecr.json
}

data "aws_iam_policy_document" "ecr" {
  statement {
    sid    = "GetAuthorizationToken"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowPushPull"
    effect = "Allow"
    actions = [
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = [var.api_lambda_ecr_arn]
  }
  statement {
    sid    = "PermissionsToUpdateFunction"
    effect = "Allow"
    actions = [
      "lambda:GetAlias",
      "lambda:GetFunction",
      "lambda:GetFunctionConfiguration",
      "lambda:ListAliases",
      "lambda:ListVersionsByFunction",
      "lambda:PublishVersion",
      "lambda:UpdateAlias",
      "lambda:UpdateFunctionCode"
    ]
    resources = [aws_lambda_function.api.arn]
  }
}
