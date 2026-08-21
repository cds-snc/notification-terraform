###
# EFS storage for the Fargate cluster
#
# The EFS CSI driver dynamically provisions access points via the `efs-ap`
# provisioning mode, so we only manage the file system, its mount targets,
# the security group and the IAM role for the CSI controller here.
#
# The Fargate cluster is only created in dev (see eks_fargate.tf), so every
# resource in this file is gated on `var.env == "dev"`.
###

###
# Security group for the EFS mount targets
###

resource "aws_security_group" "efs_fargate" {
  provider    = aws.core_services
  count       = var.env == "dev" ? 1 : 0
  name        = "notification-canada-ca-${var.env}-efs-fargate"
  description = "EFS mount targets accessed by the Fargate cluster"
  vpc_id      = var.vpc_id

  tags = {
    Name       = "notification-canada-ca-${var.env}-efs-fargate"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_security_group_rule" "efs_fargate_ingress_nfs" {
  provider                 = aws.core_services
  count                    = var.env == "dev" ? 1 : 0
  description              = "Allow NFS (2049) from the Fargate cluster security group"
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_eks_cluster.notification-canada-ca-eks-fargate-cluster[0].vpc_config[0].cluster_security_group_id
  security_group_id        = aws_security_group.efs_fargate[0].id
}

resource "aws_security_group_rule" "eks_fargate_egress_efs" {
  provider                 = aws.core_services
  count                    = var.env == "dev" ? 1 : 0
  description              = "Allow NFS (2049) egress from the Fargate cluster to the EFS mount targets"
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.efs_fargate[0].id
  security_group_id        = aws_eks_cluster.notification-canada-ca-eks-fargate-cluster[0].vpc_config[0].cluster_security_group_id
}

###
# EFS file system + mount targets
###

resource "aws_efs_file_system" "fargate" {
  provider         = aws.core_services
  count            = var.env == "dev" ? 1 : 0
  creation_token   = "notification-canada-ca-${var.env}-fargate"
  encrypted        = true
  performance_mode = "generalPurpose"
  throughput_mode  = "elastic"

  tags = {
    Name       = "notification-canada-ca-${var.env}-fargate-efs"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_efs_mount_target" "fargate" {
  provider        = aws.core_services
  count           = var.env == "dev" ? length(var.vpc_private_subnets_k8s) : 0
  file_system_id  = aws_efs_file_system.fargate[0].id
  subnet_id       = var.vpc_private_subnets_k8s[count.index]
  security_groups = [aws_security_group.efs_fargate[0].id]
}

###
# OIDC provider for the Fargate cluster (required for IRSA)
###

data "tls_certificate" "notification-canada-ca-fargate" {
  count = var.env == "dev" ? 1 : 0
  url   = aws_eks_cluster.notification-canada-ca-eks-fargate-cluster[0].identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "notification-canada-ca-fargate" {
  provider        = aws.core_services
  count           = var.env == "dev" ? 1 : 0
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.notification-canada-ca-fargate[0].certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.notification-canada-ca-eks-fargate-cluster[0].identity[0].oidc[0].issuer
}

###
# IAM role for the EFS CSI controller (IRSA)
###

data "aws_iam_policy_document" "efs_csi_controller_assume" {
  count = var.env == "dev" ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.notification-canada-ca-fargate[0].arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca-fargate[0].url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:efs-csi-controller-sa"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca-fargate[0].url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "efs_csi_controller" {
  provider           = aws.core_services
  count              = var.env == "dev" ? 1 : 0
  name               = "efs-csi-controller-eks"
  assume_role_policy = data.aws_iam_policy_document.efs_csi_controller_assume[0].json
}

resource "aws_iam_role_policy_attachment" "efs_csi_controller" {
  provider   = aws.core_services
  count      = var.env == "dev" ? 1 : 0
  role       = aws_iam_role.efs_csi_controller[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
}

###
# Expose the EFS file system ID as a Secrets Manager secret so helmfile can
# consume it as EFS_FILE_SYSTEM_ID.
###

resource "aws_secretsmanager_secret" "efs_file_system_id" {
  provider                = aws.core_services
  count                   = var.env == "dev" ? 1 : 0
  name                    = "EFS_FILE_SYSTEM_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "efs_file_system_id" {
  provider      = aws.core_services
  count         = var.env == "dev" ? 1 : 0
  secret_id     = aws_secretsmanager_secret.efs_file_system_id[0].id
  secret_string = aws_efs_file_system.fargate[0].id
}

resource "aws_secretsmanager_secret" "vpc_id" {
  provider                = aws.core_services
  count                   = var.env == "dev" ? 1 : 0
  name                    = "VPC_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "vpc_id" {
  provider      = aws.core_services
  count         = var.env == "dev" ? 1 : 0
  secret_id     = aws_secretsmanager_secret.vpc_id[0].id
  secret_string = var.vpc_id
}

###
# IAM role for the External Secrets Operator (IRSA)
###

data "aws_iam_policy_document" "external_secrets_assume" {
  count = var.env == "dev" ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.notification-canada-ca-fargate[0].arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca-fargate[0].url, "https://", "")}:sub"
      values   = ["system:serviceaccount:external-secrets:external-secrets"]
    }
  }

}

data "aws_iam_policy_document" "external_secrets_secrets_manager" {
  count = var.env == "dev" ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "external_secrets" {
  provider           = aws.core_services
  count              = var.env == "dev" ? 1 : 0
  name               = "notification-canada-ca-${var.env}-fargate-external-secrets-role"
  assume_role_policy = data.aws_iam_policy_document.external_secrets_assume[0].json
}

resource "aws_iam_role_policy" "external_secrets_secrets_manager" {
  provider = aws.core_services
  count    = var.env == "dev" ? 1 : 0
  name     = "notification-canada-ca-${var.env}-fargate-external-secrets-policy"
  role     = aws_iam_role.external_secrets[0].id
  policy   = data.aws_iam_policy_document.external_secrets_secrets_manager[0].json
}

###
# IAM role for the AWS Load Balancer Controller (IRSA)
###

data "aws_iam_policy_document" "aws_lb_controller_assume" {
  count = var.env == "dev" ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.notification-canada-ca-fargate[0].arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca-fargate[0].url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "aws_iam_role" "aws_lb_controller_fargate" {
  provider           = aws.core_services
  count              = var.env == "dev" ? 1 : 0
  name               = "notification-canada-ca-${var.env}-fargate-aws-lb-controller-role"
  assume_role_policy = data.aws_iam_policy_document.aws_lb_controller_assume[0].json
}

resource "aws_iam_role_policy_attachment" "aws_lb_controller_fargate" {
  provider   = aws.core_services
  count      = var.env == "dev" ? 1 : 0
  role       = aws_iam_role.aws_lb_controller_fargate[0].name
  policy_arn = aws_iam_policy.ALB-eks-controller-policy.arn
}

###
# IAM role for the CloudWatch agent sidecar (IRSA)
# Allows the notify-admin service account to call CloudWatch APIs.
###

data "aws_iam_policy_document" "cloudwatch_agent_fargate_assume" {
  count = var.env == "dev" ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.notification-canada-ca-fargate[0].arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca-fargate[0].url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:notification-canada-ca:notify-admin",
        "system:serviceaccount:notification-canada-ca:notify-api",
        "system:serviceaccount:notification-canada-ca:notify-celery",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca-fargate[0].url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cloudwatch_agent_fargate" {
  provider           = aws.core_services
  count              = var.env == "dev" ? 1 : 0
  name               = "notification-canada-ca-${var.env}-fargate-cloudwatch-agent-role"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_agent_fargate_assume[0].json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_fargate" {
  provider   = aws.core_services
  count      = var.env == "dev" ? 1 : 0
  role       = aws_iam_role.cloudwatch_agent_fargate[0].name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "notification_worker_fargate" {
  provider   = aws.core_services
  count      = var.env == "dev" ? 1 : 0
  role       = aws_iam_role.cloudwatch_agent_fargate[0].name
  policy_arn = aws_iam_policy.notification-worker-policy.arn
}
