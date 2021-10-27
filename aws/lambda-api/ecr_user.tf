resource "aws_iam_user" "ecr-user" {
  name = "ecr-user"
}

resource "aws_iam_access_key" "ecr-user" {
  user = aws_iam_user.ecr-user.name
}

resource "aws_iam_group_membership" "ecr" {
  name = "ecr-group-membership"
  users = [
    aws_iam_user.ecr-user.name
  ]
  group = aws_iam_group.ecr.name
}

resource "aws_iam_group" "ecr" {
  name = "ecr-api-lambda-group"
}

resource "aws_iam_group_policy_attachment" "ecr" {
  group      = aws_iam_group.ecr.name
  policy_arn = aws_iam_policy.ecr.arn
}

resource "aws_iam_policy" "ecr" {
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
    resources = [aws_ecr_repository.api-lambda.arn]
  }
}
