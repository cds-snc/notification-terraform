provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "dev"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~> 20.0"

  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::800095993820:role/eks-worker-role"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:nodes", "system:bootstrappers"]
    },
    {
      rolearn  = "arn:aws:iam::800095993820:role/AWSReservedSSO_AWSAdministratorAccess_e6e62a284c3c35fc"
      username = "AWSAdministratorAccess:{{SessionName}}"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_accounts = [
    "800095993820"
  ]
}
