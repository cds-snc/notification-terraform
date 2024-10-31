###
# EKS Secrets CSI IAM
###

# Policy
resource "aws_iam_policy" "secrets_csi" {
  name = "secrets-csi-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"
      Action = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
      ]
      Resource = "arn:aws:secretsmanager:ca-central-1:${var.account_id}:secret:*"
    }]
  })
}

resource "aws_iam_policy" "parameters_csi" {
  name = "parameters-csi-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"
      Action = [
        "ssm:Describe*",
        "ssm:Get*",
        "ssm:GetParameters",
        "ssm:GetParameter",
        "ssm:GetParametersByPath",
        "ssm:List*"
      ]
      Resource = "arn:aws:ssm:ca-central-1:${var.account_id}:parameter*"
    }]
  })
}

# EKS Worker policy Attachment



# NGINX

data "aws_iam_policy_document" "secrets_csi_assume_role_policy_nginx" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:nginx:ingress-nginx-ingress"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.notification-canada-ca.arn]
      type        = "Federated"
    }
  }
}

# Role
resource "aws_iam_role" "secrets_csi_nginx" {
  assume_role_policy = data.aws_iam_policy_document.secrets_csi_assume_role_policy_nginx.json
  name               = "secrets-csi-role-nginx"
}


# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi_nginx" {
  policy_arn = aws_iam_policy.secrets_csi.arn
  role       = aws_iam_role.secrets_csi_nginx.name
}



# Policy Attachment
resource "aws_iam_role_policy_attachment" "parameters_csi_nginx" {
  policy_arn = aws_iam_policy.parameters_csi.arn
  role       = aws_iam_role.secrets_csi_nginx.name
}



#
# BLAZER
#

data "aws_iam_policy_document" "secrets_csi_assume_role_policy_blazer" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:tools:blazer"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.notification-canada-ca.arn]
      type        = "Federated"
    }
  }
}

# Role
resource "aws_iam_role" "secrets_csi_blazer" {
  assume_role_policy = data.aws_iam_policy_document.secrets_csi_assume_role_policy_blazer.json
  name               = "secrets-csi-role-blazer"
}


# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi_blazer" {
  policy_arn = aws_iam_policy.secrets_csi.arn
  role       = aws_iam_role.secrets_csi_blazer.name
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "parameters_csi_blazer" {
  policy_arn = aws_iam_policy.parameters_csi.arn
  role       = aws_iam_role.secrets_csi_blazer.name
}

#
# GITHUB
#

data "aws_iam_policy_document" "secrets_csi_assume_role_policy_github" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:github-arc-controller:github-arc-gha-rs-controller"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.notification-canada-ca.arn]
      type        = "Federated"
    }
  }
}

# Role
resource "aws_iam_role" "secrets_csi_github" {
  assume_role_policy = data.aws_iam_policy_document.secrets_csi_assume_role_policy_github.json
  name               = "secrets-csi-role-github"
}


# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi_github" {
  policy_arn = aws_iam_policy.secrets_csi.arn
  role       = aws_iam_role.secrets_csi_github.name
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "parameters_csi_github" {
  policy_arn = aws_iam_policy.parameters_csi.arn
  role       = aws_iam_role.secrets_csi_github.name
}

#
# API
#
#
# NOTIFY-API
#

data "aws_iam_policy_document" "assume_role_policy_api" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:notification-canada-ca:notify-api"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.notification-canada-ca.arn]
      type        = "Federated"
    }
  }
}

# Role
resource "aws_iam_role" "api" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_api.json
  name               = "api-eks-role"
}


# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi_api" {
  policy_arn = aws_iam_policy.secrets_csi.arn
  role       = aws_iam_role.api.name
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "parameters_csi_api" {
  policy_arn = aws_iam_policy.parameters_csi.arn
  role       = aws_iam_role.api.name
}

resource "aws_iam_role_policy_attachment" "api_worker" {
  policy_arn = aws_iam_policy.notification-worker-policy.arn
  role       = aws_iam_role.api.name
}