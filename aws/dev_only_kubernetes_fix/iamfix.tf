provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "dev"
}

data "aws_caller_identity" "current" {}

module "eks" {
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
      rolearn  = "arn:aws:iam::${var.account_id}:role/${split("/", data.aws_caller_identity.current.arn)[1]}"
      username = "AWSAdministratorAccess:{{SessionName}}"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_accounts = [
    var.account_id
  ]
}
