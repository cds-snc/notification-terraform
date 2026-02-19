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

#
# Admin
#
#
# NOTIFY-Admin
#

data "aws_iam_policy_document" "assume_role_policy_admin" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:notification-canada-ca:notify-admin"]
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
resource "aws_iam_role" "admin" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_admin.json
  name               = "admin-eks-role"
}


# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi_admin" {
  policy_arn = aws_iam_policy.secrets_csi.arn
  role       = aws_iam_role.admin.name
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "parameters_csi_admin" {
  policy_arn = aws_iam_policy.parameters_csi.arn
  role       = aws_iam_role.admin.name
}

resource "aws_iam_role_policy_attachment" "admin_worker" {
  policy_arn = aws_iam_policy.notification-worker-policy.arn
  role       = aws_iam_role.admin.name
}

#
# Document-Download
#
#
# NOTIFY-Document-Download
#

data "aws_iam_policy_document" "assume_role_policy_document_download" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:notification-canada-ca:notify-document-download"]
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
resource "aws_iam_role" "document_download" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_document_download.json
  name               = "document-download-eks-role"
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi_document_download" {
  policy_arn = aws_iam_policy.secrets_csi.arn
  role       = aws_iam_role.document_download.name
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "parameters_csi_document_download" {
  policy_arn = aws_iam_policy.parameters_csi.arn
  role       = aws_iam_role.document_download.name
}

resource "aws_iam_role_policy_attachment" "document_download_worker" {
  policy_arn = aws_iam_policy.notification-worker-policy.arn
  role       = aws_iam_role.document_download.name
}

#
# Celery
#
#
# NOTIFY-Celery
#

data "aws_iam_policy_document" "assume_role_policy_celery" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:notification-canada-ca:notify-celery"]
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
resource "aws_iam_role" "celery" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_celery.json
  name               = "celery-eks-role"
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi_celery" {
  policy_arn = aws_iam_policy.secrets_csi.arn
  role       = aws_iam_role.celery.name
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "parameters_csi_celery" {
  policy_arn = aws_iam_policy.parameters_csi.arn
  role       = aws_iam_role.celery.name
}

resource "aws_iam_role_policy_attachment" "celery_worker" {
  policy_arn = aws_iam_policy.notification-worker-policy.arn
  role       = aws_iam_role.celery.name
}

#
# Database
#
#
# NOTIFY-Database
#

data "aws_iam_policy_document" "assume_role_policy_database" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:notification-canada-ca:notify-database"]
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
resource "aws_iam_role" "database" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_database.json
  name               = "secrets-csi-role-database"
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi_database" {
  policy_arn = aws_iam_policy.secrets_csi.arn
  role       = aws_iam_role.database.name
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "parameters_csi_database" {
  policy_arn = aws_iam_policy.parameters_csi.arn
  role       = aws_iam_role.database.name
}

resource "aws_iam_role_policy_attachment" "database_worker" {
  policy_arn = aws_iam_policy.notification-worker-policy.arn
  role       = aws_iam_role.database.name
}

#
# SIGNOZ
#

data "aws_iam_policy_document" "assume_role_policy_signoz" {
  count = var.env != "production" ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:signoz:signoz"]
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
resource "aws_iam_role" "signoz" {
  count              = var.env != "production" ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_signoz[0].json
  name               = "signoz-eks-role"
}


# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi_signoz" {
  count      = var.env != "production" ? 1 : 0
  policy_arn = aws_iam_policy.secrets_csi.arn
  role       = aws_iam_role.signoz[0].name
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "parameters_csi_signoz" {
  count      = var.env != "production" ? 1 : 0
  policy_arn = aws_iam_policy.parameters_csi.arn
  role       = aws_iam_role.signoz[0].name
}

resource "aws_iam_role_policy_attachment" "signoz_worker" {
  count      = var.env != "production" ? 1 : 0
  policy_arn = aws_iam_policy.notification-worker-policy.arn
  role       = aws_iam_role.signoz[0].name
}

#
# SIGNOZ PROMETHEUS CLOUDWATCH EXPORTER
#

resource "aws_iam_policy" "signoz_prometheus_cloudwatch_exporter" {
  count = var.env != "production" ? 1 : 0
  name  = "signoz-prometheus-cloudwatch-exporter-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "tag:GetResources",
          "ec2:DescribeTags"
        ]
        Resource = "*"
      }
    ]
  })
}

data "aws_iam_policy_document" "assume_role_policy_signoz_prometheus_cloudwatch_exporter" {
  count = var.env != "production" ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:signoz:prometheus-cloudwatch-exporter"]
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

resource "aws_iam_role" "signoz_prometheus_cloudwatch_exporter" {
  count              = var.env != "production" ? 1 : 0
  name               = "signoz-prometheus-cloudwatch-exporter-eks-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_signoz_prometheus_cloudwatch_exporter[0].json
}

resource "aws_iam_role_policy_attachment" "signoz_prometheus_cloudwatch_exporter" {
  count      = var.env != "production" ? 1 : 0
  role       = aws_iam_role.signoz_prometheus_cloudwatch_exporter[0].name
  policy_arn = aws_iam_policy.signoz_prometheus_cloudwatch_exporter[0].arn
}

## Signoz SMTP IAM User and Policy

# IAM User for SES SMTP
resource "aws_iam_user" "signoz_smtp_user" {
  count = var.env != "production" ? 1 : 0
  name  = "signoz-${var.env}"
}

# Policy for sending emails via SES
resource "aws_iam_user_policy" "signoz_smtp_user_policy" {
  count = var.env != "production" ? 1 : 0
  name  = "ses-smtp-policy"
  user  = aws_iam_user.signoz_smtp_user[0].name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ses:SendRawEmail",
          "ses:SendEmail"
        ]
        Resource = "arn:aws:ses:*:${var.account_id}:identity/*"
      }
    ]
  })
}

# Access key for SMTP credentials
resource "aws_iam_access_key" "signoz_smtp_user_key" {
  count = var.env != "production" ? 1 : 0
  user  = aws_iam_user.signoz_smtp_user[0].name
}

#
# FALCO SIDEKICK UI
#

data "aws_iam_policy_document" "assume_role_policy_falco_sidekick_ui" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:falco:falco-falcosidekick-ui"]
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
resource "aws_iam_role" "falco_sidekick_ui" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_falco_sidekick_ui.json
  name               = "falco-sidekick-ui-eks-role"
}


# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi_falco_sidekick_ui" {
  policy_arn = aws_iam_policy.secrets_csi.arn
  role       = aws_iam_role.falco_sidekick_ui.name
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "parameters_csi_falco_sidekick_ui" {
  policy_arn = aws_iam_policy.parameters_csi.arn
  role       = aws_iam_role.falco_sidekick_ui.name
}

resource "aws_iam_role_policy_attachment" "falco_sidekick_ui_worker" {
  policy_arn = aws_iam_policy.notification-worker-policy.arn
  role       = aws_iam_role.falco_sidekick_ui.name
}

#
# FALCO SIDEKICK
#

data "aws_iam_policy_document" "assume_role_policy_falco_sidekick" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:falco:falco-falcosidekick"]
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
resource "aws_iam_role" "falco_sidekick" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_falco_sidekick.json
  name               = "falco-sidekick-eks-role"
}


# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi_falco_sidekick" {
  policy_arn = aws_iam_policy.secrets_csi.arn
  role       = aws_iam_role.falco_sidekick.name
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "parameters_csi_falco_sidekick" {
  policy_arn = aws_iam_policy.parameters_csi.arn
  role       = aws_iam_role.falco_sidekick.name
}

resource "aws_iam_role_policy_attachment" "falco_sidekick_worker" {
  policy_arn = aws_iam_policy.notification-worker-policy.arn
  role       = aws_iam_role.falco_sidekick.name
}
