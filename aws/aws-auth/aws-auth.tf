provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = var.env
}

data "aws_caller_identity" "current" {}

data "external" "aws_role_name" {
  # Get the role name from AWS using a script
  program = ["./getRoleName.sh"]
}

locals {
  notification_namespace_admin_group = "notification-canada-ca-admins"
  notification_helmfile_diff_group   = "notification-manifests-helmfile-diff-readonly"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~> 20.0"

  manage_aws_auth_configmap = true

  aws_auth_roles = concat(
    [
      {
        rolearn  = "arn:aws:iam::${var.account_id}:role/eks-worker-role"
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:nodes", "system:bootstrappers"]
      },
      {
        rolearn  = "arn:aws:iam::${var.account_id}:role/${data.external.aws_role_name.result.rolename}"
        username = "AWSAdministratorAccess:{{SessionName}}"
        groups   = ["system:masters"]
      },
      {
        rolearn  = "arn:aws:iam::${var.account_id}:role/notification-admin-apply"
        username = "notification-admin-apply"
        groups   = [local.notification_namespace_admin_group]
      },
      {
        rolearn  = "arn:aws:iam::${var.account_id}:role/notification-api-apply"
        username = "notification-api-apply"
        groups   = [local.notification_namespace_admin_group]
      },
      {
        rolearn  = "arn:aws:iam::${var.account_id}:role/notification-document-download-api-apply"
        username = "notification-document-download-api-apply"
        groups   = [local.notification_namespace_admin_group]
      },
      {
        rolearn  = "arn:aws:iam::${var.account_id}:role/notification-documentation-apply"
        username = "notification-documentation-apply"
        groups   = [local.notification_namespace_admin_group]
      },
      {
        rolearn  = "arn:aws:iam::${var.account_id}:role/notification-manifests-apply"
        username = "notification-manifests-apply"
        groups   = ["system:masters"]
      },
      {
        rolearn  = "arn:aws:iam::${var.account_id}:role/notification-terraform-apply"
        username = "notification-terraform-apply"
        groups   = ["system:masters"]
      },
      {
        rolearn  = "arn:aws:iam::${var.account_id}:role/notification-terraform-plan"
        username = "notification-terraform-plan"
        groups   = [local.notification_helmfile_diff_group]
      },
      {
        rolearn  = "arn:aws:iam::${var.account_id}:role/ipv4-geolocate-webservice-apply"
        username = "ipv4-geolocate-webservice-apply"
        groups   = [local.notification_namespace_admin_group]
      },
      {
        rolearn  = "arn:aws:iam::${var.account_id}:role/notification-geolocate-apply"
        username = "notification-geolocate-apply"
        groups   = ["system:masters"]
      },
      {
        rolearn  = "arn:aws:iam::${var.account_id}:role/notification-manifests-helmfile-diff"
        username = "notification-manifests-helmfile-diff"
        groups   = [local.notification_helmfile_diff_group]
      },
      {
        rolearn  = "arn:aws:iam::${var.account_id}:role/notification-manifests-k8s-lambda-apply-main-branch"
        username = "notification-manifests-k8s-lambda-apply-main-branch"
        groups   = ["system:masters"]
      },
    ],
    var.env == "staging" ? [
      {
        rolearn  = "arn:aws:iam::${var.account_id}:role/notification-manifests-helmfile-staging-apply"
        username = "notification-manifests-helmfile-staging-apply"
        groups   = ["system:masters"]
      },
      {
        rolearn  = "arn:aws:iam::${var.account_id}:role/notification-manifests-database-migration-staging"
        username = "notification-manifests-database-migration-staging"
        groups   = [local.notification_namespace_admin_group]
      },
    ] : [],
    var.env == "production" ? [
      {
        rolearn  = "arn:aws:iam::${var.account_id}:role/notification-manifests-helmfile-production-apply"
        username = "notification-manifests-helmfile-production-apply"
        groups   = ["system:masters"]
      },
      {
        rolearn  = "arn:aws:iam::${var.account_id}:role/notification-manifests-database-migration-production"
        username = "notification-manifests-database-migration-production"
        groups   = [local.notification_namespace_admin_group]
      },
    ] : [],
  )

  aws_auth_accounts = [
    var.account_id
  ]
}

resource "kubernetes_role_binding_v1" "notification_namespace_admins" {
  metadata {
    name      = "notification-namespace-admins"
    namespace = "notification-canada-ca"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin"
  }

  subject {
    kind      = "Group"
    name      = local.notification_namespace_admin_group
    api_group = "rbac.authorization.k8s.io"
  }

  depends_on = [module.eks]
}

resource "kubernetes_cluster_role_binding_v1" "notification_helmfile_diff_view" {
  metadata {
    name = "notification-manifests-helmfile-diff-view"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }

  subject {
    kind      = "Group"
    name      = local.notification_helmfile_diff_group
    api_group = "rbac.authorization.k8s.io"
  }

  depends_on = [module.eks]
}

resource "kubernetes_cluster_role_v1" "notification_helmfile_diff_secrets" {
  metadata {
    name = "notification-manifests-helmfile-diff-secrets"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding_v1" "notification_helmfile_diff_secrets" {
  metadata {
    name = "notification-manifests-helmfile-diff-secrets"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.notification_helmfile_diff_secrets.metadata[0].name
  }

  subject {
    kind      = "Group"
    name      = local.notification_helmfile_diff_group
    api_group = "rbac.authorization.k8s.io"
  }

  depends_on = [module.eks]
}
