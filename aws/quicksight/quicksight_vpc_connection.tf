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
}

resource "aws_iam_policy" "quicksight_vpc_connection_iam" {
  name        = "quicksight-vpc-connection-iam"
  description = "IAM permissions for the Quicksight VPC connection"
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

resource "aws_iam_role_policy_attachment" "iam-qs-attach" {
  role       = aws_iam_role.vpc_connection_role.name
  policy_arn = aws_iam_policy.quicksight_vpc_connection_iam.arn
}

resource "aws_iam_policy" "quicksight_vpc_connection_ec2" {
  name        = "quicksight-vpc-connection-ec2"
  description = "EC2 permissions for the Quicksight VPC connection"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:ModifyNetworkInterfaceAttribute",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups"
        ]
        Resource = ["*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2-qs-attach" {
  role       = aws_iam_role.vpc_connection_role.name
  policy_arn = aws_iam_policy.quicksight_vpc_connection_ec2.arn
}
