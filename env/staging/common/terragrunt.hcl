terraform {
  source = "../../../aws//common"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  elasticache_node_type   = "cache.t3.micro"
  sns_monthly_spend_limit = 1
  vpc_private_subnets     = dependency.common.outputs.vpc_private_subnets
}
