terraform {
  source = "../../../aws//performance-test"
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
  mock_outputs = {
    eks-cluster-securitygroup = ""
  }
}

dependency "ecr" {
  config_path = "../ecr"
}


include {
  path = find_in_parent_folders()
}

inputs = {
  eks_cluster_securitygroup = dependency.eks.outputs.eks-cluster-securitygroup
  vpc_public_subnets        = dependency.common.outputs.vpc_public_subnets
  vpc_id                    = dependency.common.outputs.vpc_id
  private-links-vpc-endpoints-securitygroup   = dependency.common.outputs.private-links-vpc-endpoints-securitygroup
  private-links-gateway-prefix-list-ids       = dependency.common.outputs.private-links-gateway-prefix-list-ids
  performance_test_ecr_repository_url         = dependency.ecr.outputs.performance_test_ecr_repository_url
}
