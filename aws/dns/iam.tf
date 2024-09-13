resource "aws_iam_role_policy" "scratch_dns_manager_policy" {
  count = var.env == "staging" ? 1 : 0
  name  = "scratch_dns_manager_policy"
  role  = aws_iam_role.scratch_dns_manager[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["route53:GetHostedZone",
        "route53:ListResourceRecordSets",
        "route53:ListHostedZones",
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets",
        "route53:GetHostedZoneCount",
        "route53:ListHostedZonesByName",
        "route53:GetChange"
      ]
      Resource = ["*"]
    }]
  })
}

resource "aws_iam_role" "scratch_dns_manager" {
  count = var.env == "staging" ? 1 : 0
  name  = "scratch_dns_manager_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "419291849580"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "staging_dns_manager_policy" {
  count = var.env == "staging" ? 1 : 0
  name  = "staging_dns_manager_policy"
  role  = aws_iam_role.staging_dns_manager[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["route53:GetHostedZone",
        "route53:ListResourceRecordSets",
        "route53:ListHostedZones",
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets",
        "route53:GetHostedZoneCount",
        "route53:ListHostedZonesByName",
        "route53:GetChange"
      ]
      Resource = ["*"]
    }]
  })
}

resource "aws_iam_role" "staging_dns_manager" {
  count = var.env == "staging" ? 1 : 0
  name  = "staging_dns_manager_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "239043911459"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "production_dns_manager_policy" {
  count = var.env == "staging" ? 1 : 0
  name  = "production_dns_manager_policy"
  role  = aws_iam_role.production_dns_manager[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["route53:GetHostedZone",
        "route53:ListResourceRecordSets",
        "route53:ListHostedZones",
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets",
        "route53:GetHostedZoneCount",
        "route53:ListHostedZonesByName",
        "route53:GetChange"
      ]
      Resource = ["*"]
    }]
  })
}

resource "aws_iam_role" "production_dns_manager" {
  count = var.env == "staging" ? 1 : 0
  name  = "production_dns_manager_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "296255494825"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "dev_dns_manager_policy" {
  count = var.env == "staging" ? 1 : 0
  name  = "dev_dns_manager_policy"
  role  = aws_iam_role.dev_dns_manager[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["route53:GetHostedZone",
        "route53:ListResourceRecordSets",
        "route53:ListHostedZones",
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets",
        "route53:GetHostedZoneCount",
        "route53:ListHostedZonesByName",
        "route53:GetChange"
      ]
      Resource = ["*"]
    }]
  })
}

resource "aws_iam_role" "dev_dns_manager" {
  count = var.env == "staging" ? 1 : 0
  name  = "dev_dns_manager_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = [
            "800095993820",
            "arn:aws:iam::800095993820:role/notification-terraform-apply",
            "arn:aws:iam::800095993820:role/notification-terraform-plan",
            "arn:aws:sts::800095993820:assumed-role/notification-terraform-plan/NotifyTerraformPlan"
          ]
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "sandbox_dns_manager_policy" {
  count = var.env == "staging" ? 1 : 0
  name  = "sandbox_dns_manager_policy"
  role  = aws_iam_role.sandbox_dns_manager[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["route53:GetHostedZone",
        "route53:ListResourceRecordSets",
        "route53:ListHostedZones",
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets",
        "route53:GetHostedZoneCount",
        "route53:ListHostedZonesByName",
        "route53:GetChange"
      ]
      Resource = ["*"]
    }]
  })
}

resource "aws_iam_role" "sandbox_dns_manager" {
  count = var.env == "staging" ? 1 : 0
  name  = "sandbox_dns_manager_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "891376947407"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}