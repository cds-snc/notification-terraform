resource "aws_quicksight_vpc_connection" "rds" {
  vpc_connection_id  = var.vpc_id
  name               = "Quicksight RDS connection"
  role_arn           = aws_iam_role.vpc_connection_role.arn
  security_group_ids = [var.quicksight_security_group_id]
  subnet_ids         = var.database_subnet_ids
}

resource "aws_iam_role" "vpc_connection_role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "quicksight.amazonaws.com"
        }
      }
    ]
  })
  inline_policy {
    name = "QuickSightVPCConnectionRolePolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          "Action" : [
            "iam:GetRole",
            "iam:DetachRolePolicy",
            "iam:DeleteRole",
            "iam:AttachRolePolicy",
            "iam:CreateRole"
          ],
          "Effect" : "Allow",
          "Resource" : [
            "arn:aws:iam::${var.account_id}:role/service-role/aws-quicksight-service-role-v0",
            "arn:aws:iam::${var.account_id}:role/service-role/aws-quicksight-s3-consumers-role-v0"
          ],
          "Sid" : "VisualEditor0"
        },
        {
          "Action" : [
            "iam:ListPolicies",
            "iam:GetPolicyVersion",
            "iam:GetRole",
            "iam:GetPolicy",
            "iam:ListPolicyVersions",
            "iam:ListAttachedRolePolicies",
            "iam:GenerateServiceLastAccessedDetails",
            "iam:ListEntitiesForPolicy",
            "iam:ListPoliciesGrantingServiceAccess",
            "iam:ListRoles",
            "iam:GetServiceLastAccessedDetails",
            "iam:ListAccountAliases",
            "iam:ListRolePolicies",
            "s3:ListAllMyBuckets"
          ],
          "Effect" : "Allow",
          "Resource" : "*",
          "Sid" : "VisualEditor1"
        },
        {
          "Action" : [
            "iam:DeletePolicy",
            "iam:CreatePolicy",
            "iam:CreatePolicyVersion",
            "iam:DeletePolicyVersion"
          ],
          "Effect" : "Allow",
          "Resource" : [
            "arn:aws:iam::${var.account_id}:policy/service-role/AWSQuickSightIAMPolicy",
            "arn:aws:iam::${var.account_id}:policy/service-role/AWSQuickSightRDSPolicy",
            "arn:aws:iam::${var.account_id}:policy/service-role/AWSQuickSightS3Policy",
            "arn:aws:iam::${var.account_id}:policy/service-role/AWSQuickSightRedshiftPolicy",
            "arn:aws:iam::${var.account_id}:policy/service-role/AWSQuickSightS3ConsumersPolicy"
          ],
          "Sid" : "VisualEditor2"
        }
      ]
    })
  }
}

