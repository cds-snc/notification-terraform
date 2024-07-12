module "oidc" {
  source            = "github.com/cds-snc/terraform-modules?ref=v2.0.1//gh_oidc_role"
  billing_tag_key   = "CostCentre"
  billing_tag_value = var.billing_tag_value
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
          "Action": [
              "ecr:CompleteLayerUpload",
              "ecr:GetAuthorizationToken",
              "ecr:UploadLayerPart",
              "ecr:InitiateLayerUpload",
              "ecr:BatchCheckLayerAvailability",
              "ecr:PutImage",
              "ecr:BatchGetImage"
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


