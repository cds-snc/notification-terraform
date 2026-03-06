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
        "AWS": "${var.scratch_account_id}"
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
        "AWS": "${var.staging_account_id}"
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
        "AWS": "${var.production_account_id}"
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

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "${var.dev_account_id}"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
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
        "AWS": "${var.sandbox_account_id}"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "cert_manager_dns01" {
  count    = var.env == "staging" || var.env == "production" ? 1 : 0
  provider = aws.dns
  name     = "cert-manager-dns01"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          AWS = var.env == "production" ? [
            "arn:aws:iam::${var.production_account_id}:root"
            ] : [
            "arn:aws:iam::${var.dev_account_id}:root",
            "arn:aws:iam::${var.staging_account_id}:root",
            "arn:aws:iam::${var.sandbox_account_id}:root"
          ]
        }
        Condition = {
          StringLike = {
            "aws:PrincipalArn" = var.env == "production" ? [
              "arn:aws:iam::${var.production_account_id}:role/cert-manager-route53-eks-role",
              "arn:aws:sts::${var.production_account_id}:assumed-role/cert-manager-route53-eks-role/*"
              ] : [
              "arn:aws:iam::${var.dev_account_id}:role/cert-manager-route53-eks-role",
              "arn:aws:sts::${var.dev_account_id}:assumed-role/cert-manager-route53-eks-role/*",
              "arn:aws:iam::${var.staging_account_id}:role/cert-manager-route53-eks-role",
              "arn:aws:sts::${var.staging_account_id}:assumed-role/cert-manager-route53-eks-role/*",
              "arn:aws:iam::${var.sandbox_account_id}:role/cert-manager-route53-eks-role",
              "arn:aws:sts::${var.sandbox_account_id}:assumed-role/cert-manager-route53-eks-role/*"
            ]
          }
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "cert_manager_dns01_policy" {
  count    = var.env == "staging" || var.env == "production" ? 1 : 0
  provider = aws.dns
  name     = "cert_manager_dns01_policy"
  role     = aws_iam_role.cert_manager_dns01[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ]
        Resource = [
          "arn:aws:route53:::hostedzone/${var.env == "production" ? aws_route53_zone.notification-canada-ca[0].zone_id : aws_route53_zone.notification-sandbox[0].zone_id}"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "route53:GetChange"
        ]
        Resource = [
          "arn:aws:route53:::change/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "route53:ListHostedZonesByName"
        ]
        Resource = [
          "*"
        ]
      }
    ]
  })
}
