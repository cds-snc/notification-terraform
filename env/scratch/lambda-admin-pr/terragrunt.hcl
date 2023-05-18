dependencies {
  paths = ["../common", "../elasticache", "../ecr"]
}

dependency "common" {
  config_path = "../common"

  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    private-links-gateway-prefix-list-ids     = []
    private-links-vpc-endpoints-securitygroup = ""
    vpc_id                                    = ""
  }
}

dependency "ecr" {
  config_path = "../ecr"
}


dependency "elasticache" {
  config_path = "../elasticache"

  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    redis_cluster_security_group_id = ""
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  redis_cluster_security_group_id      = dependency.elasticache.outputs.redis_cluster_security_group_id
  vpc_id                               = dependency.common.outputs.vpc_id
  vpc_endpoint_gateway_prefix_list_ids = dependency.common.outputs.private-links-gateway-prefix-list-ids
  vpc_endpoint_security_group_id       = dependency.common.outputs.private-links-vpc-endpoints-securitygroup
  notify_admin_ecr_arn                 = dependency.ecr.outputs.notify_admin_ecr_arn
}

terraform {
  source = "../../../aws//lambda-admin-pr"
}
