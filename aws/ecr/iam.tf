resource "aws_iam_role" "github_docker_push" {
  name = "github_docker_push"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = <<ROLE
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "",
          "Effect": "Allow",
          "Principal": {
              "Federated": "arn:aws:iam::283582579564:oidc-provider/token.actions.githubusercontent.com"
          },
          "Action": "sts:AssumeRoleWithWebIdentity",
          "Condition": {
              "StringLike": {
                  "token.actions.githubusercontent.com:sub": "repo:cds-snc/notification-terraform:ref:refs/heads/main"
              }
          }
      }
  ]
}
ROLE

}

resource "aws_iam_role_policy" "github_docker_push" {
  name = "github_docker_push"
  role = aws_iam_role.github_docker_push.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "ecr:CompleteLayerUpload",
              "ecr:GetAuthorizationToken",
              "ecr:UploadLayerPart",
              "ecr:InitiateLayerUpload",
              "ecr:BatchCheckLayerAvailability",
              "ecr:PutImage"
          ],
          "Resource": "arn:aws:ecr:${var.region}:${var.account_id}:repository/*"
        },
        {
            "Effect": "Allow",
            "Action": "ecr:GetAuthorizationToken",
            "Resource": "*"
        }
  ]
}
POLICY
}