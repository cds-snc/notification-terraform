module "oidc" {
  source            = "github.com/cds-snc/terraform-modules//gh_oidc_role?ref=0486d25810b72dada323cd64f20657f1e42ca119" # v2.0.5
  billing_tag_key   = "CostCentre"
  billing_tag_value = "notification-canada-ca-${var.env}"
  oidc_exists       = true
  roles = [
    {
      name : "github_docker_push"
      repo_name : "notification-terraform"
      claim : "ref:refs/heads/*"
    }
  ]
}


resource "aws_iam_role_policy" "github_docker_push" {
  provider = aws.core_services

  depends_on = [module.oidc]

  name = "github_docker_push"
  role = "github_docker_push"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ecr:GetAuthorizationToken",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:GetDownloadUrlForLayer",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ],
      "Resource": [
        "arn:aws:ecr:${var.region}:${var.account_id}:repository/*",
        "arn:aws:ecr:us-west-2:${var.account_id}:repository/*",
        "arn:aws:ecr:us-east-1:${var.account_id}:repository/notify/ses_receiving_emails"
      ]
    }
  ]
}
POLICY
}


