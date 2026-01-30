###
# EKS Auto Secrets CSI IAM
###

# Policy
resource "aws_iam_policy" "secrets_csi_auto" {
  count = var.env == "dev" ? 1 : 0
  name  = "secrets-csi-policy-auto"

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

resource "aws_iam_policy" "parameters_csi_auto" {
  count = var.env == "dev" ? 1 : 0
  name  = "parameters-csi-policy-auto"

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

data "aws_iam_policy_document" "secrets_csi_assume_role_policy_nginx_auto" {
  count = var.env == "dev" ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_auto[0].url, "https://", "")}:sub"
      values   = ["system:serviceaccount:nginx:ingress-nginx-ingress"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_auto[0].url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_auto[0].arn]
      type        = "Federated"
    }
  }
}

# Role
resource "aws_iam_role" "secrets_csi_nginx_auto" {
  count              = var.env == "dev" ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.secrets_csi_assume_role_policy_nginx_auto[0].json
  name               = "secrets-csi-role-nginx-auto"
}


# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi_nginx_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.secrets_csi_auto[0].arn
  role       = aws_iam_role.secrets_csi_nginx_auto[0].name
}



# Policy Attachment
resource "aws_iam_role_policy_attachment" "parameters_csi_nginx_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.parameters_csi_auto[0].arn
  role       = aws_iam_role.secrets_csi_nginx_auto[0].name
}



#
# BLAZER
#

data "aws_iam_policy_document" "secrets_csi_assume_role_policy_blazer_auto" {
  count = var.env == "dev" ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_auto[0].url, "https://", "")}:sub"
      values   = ["system:serviceaccount:tools:blazer"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_auto[0].url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_auto[0].arn]
      type        = "Federated"
    }
  }
}

# Role
resource "aws_iam_role" "secrets_csi_blazer_auto" {
  count              = var.env == "dev" ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.secrets_csi_assume_role_policy_blazer_auto[0].json
  name               = "secrets-csi-role-blazer-auto"
}


# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi_blazer_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.secrets_csi_auto[0].arn
  role       = aws_iam_role.secrets_csi_blazer_auto[0].name
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "parameters_csi_blazer_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.parameters_csi_auto[0].arn
  role       = aws_iam_role.secrets_csi_blazer_auto[0].name
}

#
# API
#
#
# NOTIFY-API
#

data "aws_iam_policy_document" "assume_role_policy_api_auto" {
  count = var.env == "dev" ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_auto[0].url, "https://", "")}:sub"
      values   = ["system:serviceaccount:notification-canada-ca:notify-api"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_auto[0].url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_auto[0].arn]
      type        = "Federated"
    }
  }
}

# Role
resource "aws_iam_role" "api_auto" {
  count              = var.env == "dev" ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_api_auto[0].json
  name               = "api-eks-role-auto"
}


# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi_api_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.secrets_csi_auto[0].arn
  role       = aws_iam_role.api_auto[0].name
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "parameters_csi_api_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.parameters_csi_auto[0].arn
  role       = aws_iam_role.api_auto[0].name
}

resource "aws_iam_role_policy_attachment" "api_worker_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.notification-worker-policy.arn
  role       = aws_iam_role.api_auto[0].name
}

#
# Admin
#
#
# NOTIFY-Admin
#

data "aws_iam_policy_document" "assume_role_policy_admin_auto" {
  count = var.env == "dev" ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_auto[0].url, "https://", "")}:sub"
      values   = ["system:serviceaccount:notification-canada-ca:notify-admin"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_auto[0].url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_auto[0].arn]
      type        = "Federated"
    }
  }
}

# Role
resource "aws_iam_role" "admin_auto" {
  count              = var.env == "dev" ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_admin_auto[0].json
  name               = "admin-eks-role-auto"
}


# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi_admin_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.secrets_csi_auto[0].arn
  role       = aws_iam_role.admin_auto[0].name
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "parameters_csi_admin_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.parameters_csi_auto[0].arn
  role       = aws_iam_role.admin_auto[0].name
}

resource "aws_iam_role_policy_attachment" "admin_worker_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.notification-worker-policy.arn
  role       = aws_iam_role.admin_auto[0].name
}

#
# Document-Download
#
#
# NOTIFY-Document-Download
#

data "aws_iam_policy_document" "assume_role_policy_document_download_auto" {
  count = var.env == "dev" ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_auto[0].url, "https://", "")}:sub"
      values   = ["system:serviceaccount:notification-canada-ca:notify-document-download"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_auto[0].url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_auto[0].arn]
      type        = "Federated"
    }
  }
}

# Role
resource "aws_iam_role" "document_download_auto" {
  count              = var.env == "dev" ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_document_download_auto[0].json
  name               = "document-download-eks-role-auto"
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi_document_download_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.secrets_csi_auto[0].arn
  role       = aws_iam_role.document_download_auto[0].name
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "parameters_csi_document_download_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.parameters_csi_auto[0].arn
  role       = aws_iam_role.document_download_auto[0].name
}

resource "aws_iam_role_policy_attachment" "document_download_worker_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.notification-worker-policy.arn
  role       = aws_iam_role.document_download_auto[0].name
}

#
# Celery
#
#
# NOTIFY-Celery
#

data "aws_iam_policy_document" "assume_role_policy_celery_auto" {
  count = var.env == "dev" ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_auto[0].url, "https://", "")}:sub"
      values   = ["system:serviceaccount:notification-canada-ca:notify-celery"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_auto[0].url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_auto[0].arn]
      type        = "Federated"
    }
  }
}

# Role
resource "aws_iam_role" "celery_auto" {
  count              = var.env == "dev" ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_celery_auto[0].json
  name               = "celery-eks-role-auto"
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi_celery_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.secrets_csi_auto[0].arn
  role       = aws_iam_role.celery_auto[0].name
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "parameters_csi_celery_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.parameters_csi_auto[0].arn
  role       = aws_iam_role.celery_auto[0].name
}

resource "aws_iam_role_policy_attachment" "celery_worker_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.notification-worker-policy.arn
  role       = aws_iam_role.celery_auto[0].name
}

#
# Database
#
#
# NOTIFY-Database
#

data "aws_iam_policy_document" "assume_role_policy_database_auto" {
  count = var.env == "dev" ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_auto[0].url, "https://", "")}:sub"
      values   = ["system:serviceaccount:notification-canada-ca:notify-database"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_auto[0].url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_auto[0].arn]
      type        = "Federated"
    }
  }
}

# Role
resource "aws_iam_role" "database_auto" {
  count              = var.env == "dev" ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_database_auto[0].json
  name               = "secrets-csi-role-database-auto"
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi_database_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.secrets_csi_auto[0].arn
  role       = aws_iam_role.database_auto[0].name
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "parameters_csi_database_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.parameters_csi_auto[0].arn
  role       = aws_iam_role.database_auto[0].name
}

resource "aws_iam_role_policy_attachment" "database_worker_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.notification-worker-policy.arn
  role       = aws_iam_role.database_auto[0].name
}

#
# SIGNOZ
#

data "aws_iam_policy_document" "assume_role_policy_signoz_auto" {
  count = var.env == "dev" ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_auto[0].url, "https://", "")}:sub"
      values   = ["system:serviceaccount:signoz:signoz"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_auto[0].url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_auto[0].arn]
      type        = "Federated"
    }
  }
}

# Role
resource "aws_iam_role" "signoz_auto" {
  count              = var.env == "dev" ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_signoz_auto[0].json
  name               = "signoz-eks-role-auto"
}


# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi_signoz_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.secrets_csi_auto[0].arn
  role       = aws_iam_role.signoz_auto[0].name
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "parameters_csi_signoz_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.parameters_csi_auto[0].arn
  role       = aws_iam_role.signoz_auto[0].name
}

resource "aws_iam_role_policy_attachment" "signoz_worker_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.notification-worker-policy.arn
  role       = aws_iam_role.signoz_auto[0].name
}

#
# FALCO SIDEKICK UI
#

data "aws_iam_policy_document" "assume_role_policy_falco_sidekick_ui_auto" {
  count = var.env == "dev" ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_auto[0].url, "https://", "")}:sub"
      values   = ["system:serviceaccount:falco:falco-falcosidekick-ui"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_auto[0].url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_auto[0].arn]
      type        = "Federated"
    }
  }
}

# Role
resource "aws_iam_role" "falco_sidekick_ui_auto" {
  count              = var.env == "dev" ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_falco_sidekick_ui_auto[0].json
  name               = "falco-sidekick-ui-eks-role-auto"
}


# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi_falco_sidekick_ui_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.secrets_csi_auto[0].arn
  role       = aws_iam_role.falco_sidekick_ui_auto[0].name
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "parameters_csi_falco_sidekick_ui_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.parameters_csi_auto[0].arn
  role       = aws_iam_role.falco_sidekick_ui_auto[0].name
}

resource "aws_iam_role_policy_attachment" "falco_sidekick_ui_worker_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.notification-worker-policy.arn
  role       = aws_iam_role.falco_sidekick_ui_auto[0].name
}

#
# FALCO SIDEKICK
#

data "aws_iam_policy_document" "assume_role_policy_falco_sidekick_auto" {
  count = var.env == "dev" ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_auto[0].url, "https://", "")}:sub"
      values   = ["system:serviceaccount:falco:falco-falcosidekick"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_auto[0].url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_auto[0].arn]
      type        = "Federated"
    }
  }
}

# Role
resource "aws_iam_role" "falco_sidekick_auto" {
  count              = var.env == "dev" ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_falco_sidekick_auto[0].json
  name               = "falco-sidekick-eks-role-auto"
}


# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi_falco_sidekick_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.secrets_csi_auto[0].arn
  role       = aws_iam_role.falco_sidekick_auto[0].name
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "parameters_csi_falco_sidekick_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.parameters_csi_auto[0].arn
  role       = aws_iam_role.falco_sidekick_auto[0].name
}

resource "aws_iam_role_policy_attachment" "falco_sidekick_worker_auto" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.notification-worker-policy.arn
  role       = aws_iam_role.falco_sidekick_auto[0].name
}
