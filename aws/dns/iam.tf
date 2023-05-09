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

resource "aws_iam_role_policy" "prod_dns_manager_policy" {
  count = var.env == "staging" ? 1 : 0
  name  = "prod_dns_manager_policy"
  role  = aws_iam_role.prod_dns_manager[0].id

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

resource "aws_iam_role" "prod_dns_manager" {
  count = var.env == "staging" ? 1 : 0
  name  = "prod_dns_manager_role"

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
