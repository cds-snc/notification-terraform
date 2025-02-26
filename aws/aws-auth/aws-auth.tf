provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = var.env
}

data "aws_caller_identity" "current" {}

data "external" "aws_role_name" {
  # Get the role name from aws
  program = ["./getRoleName.sh"]
}

module "eks" {
  count   = var.env != "production" ? 1 : 0
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~> 20.0"

  manage_aws_auth_configmap = true

  aws_auth_roles = [
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
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::${var.account_id}:role/notification-api-apply"
      username = "notification-api-apply"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::${var.account_id}:role/notification-document-download-api-apply"
      username = "notification-document-download-api-apply"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::${var.account_id}:role/notification-documentation-apply"
      username = "notification-documentation-apply"
      groups   = ["system:masters"]
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
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::${var.account_id}:role/ipv4-geolocate-webservice-apply"
      username = "ipv4-geolocate-webservice-apply"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_accounts = [
    var.account_id
  ]
}
