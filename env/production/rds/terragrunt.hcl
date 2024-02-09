terraform {
  source = "../../../aws//rds"
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
  kms_arn                   = dependency.common.outputs.kms_arn
  rds_instance_count        = 3
  rds_instance_type         = "db.r6g.large"
  vpc_private_subnets       = dependency.common.outputs.vpc_private_subnets
  sns_alert_general_arn     = dependency.common.outputs.sns_alert_general_arn
  rds_database_name         = "NotificationCanadaCaproduction"
}
