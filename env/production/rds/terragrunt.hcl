terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/rds?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}

dependencies {
  paths = ["../common", "../eks"]
}

dependency "common" {
  config_path = "../common"
}

dependency "eks" {
  config_path = "../eks"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  eks_cluster_securitygroup = dependency.eks.outputs.eks-cluster-securitygroup
  rds_instance_count        = 3
  rds_instance_type         = "db.t3.medium"
  vpc_private_subnets       = dependency.common.outputs.vpc_private_subnets
  sns_alert_warning_arn     = dependency.common.outputs.sns_alert_warning_arn
}
