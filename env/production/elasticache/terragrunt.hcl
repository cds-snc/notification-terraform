terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/elasticache?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
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
  eks_cluster_securitygroup              = dependency.eks.outputs.eks-cluster-securitygroup
  elasticache_node_count                 = 1
  elasticache_node_number_cache_clusters = 3
  elasticache_node_type                  = "cache.t3.micro"
  vpc_private_subnets                    = dependency.common.outputs.vpc_private_subnets
  sns_alert_warning_arn                  = dependency.common.outputs.sns_alert_warning_arn
  sns_alert_critical_arn                 = dependency.common.outputs.sns_alert_critical_arn
  vpc_id                                 = dependency.common.outputs.vpc_id
  kms_arn                                = dependency.common.outputs.kms_arn
}
