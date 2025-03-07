terraform {
  source = "${get_env("ENVIRONMENT") == "production" ? "git::https://github.com/cds-snc/notification-terraform//aws/performance-test?ref=v${get_env("INFRASTRUCTURE_VERSION")}" : "../../../aws//performance-test"}"
}

dependencies {
  paths = ["../common", "../eks", "../ecr"]
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    vpc_id = ""
    vpc_public_subnets = [
      "",
      "",
      "",
    ]
    private-links-vpc-endpoints-securitygroup = ""
    private-links-gateway-prefix-list-ids = []
  }
}

dependency "eks" {
  config_path = "../eks"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    eks-cluster-securitygroup = ""
    perf_test_security_group_id = ""
  }
}

dependency "ecr" {
  config_path = "../ecr"
}

dependency "rds" {
  config_path = "../rds"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    database_read_only_proxy_endpoint = "thisisamockstring_database_read_only_proxy_endpoint"
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  eks_cluster_securitygroup                   = dependency.eks.outputs.eks-cluster-securitygroup
  vpc_public_subnets                          = dependency.common.outputs.vpc_public_subnets
  vpc_id                                      = dependency.common.outputs.vpc_id
  private-links-vpc-endpoints-securitygroup   = dependency.common.outputs.private-links-vpc-endpoints-securitygroup
  private-links-gateway-prefix-list-ids       = dependency.common.outputs.private-links-gateway-prefix-list-ids
  performance_test_ecr_repository_url         = dependency.ecr.outputs.performance_test_ecr_repository_url
  database_read_only_proxy_endpoint           = dependency.rds.outputs.database_read_only_proxy_endpoint
  perf_test_security_group_id                 = dependency.eks.outputs.perf_test_security_group_id
}
