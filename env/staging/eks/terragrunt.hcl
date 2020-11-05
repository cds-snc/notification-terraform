dependencies {
  paths = ["../common"]
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    vpc_private_subnets = [
      "subnet-001e585d12cce4d1e",
      "subnet-08de34a9e1a7458dc",
      "subnet-0af8b8402f1d605ff",
    ]
    vpc_public_subnets = [
      "subnet-0cecd9e634daf82d3",
      "subnet-0c7d18c0c51b28b61",
      "subnet-0c91f7c6b8211904b",
    ]
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  primary_worker_desired_size   = 1
  primary_worker_instance_types = ["t3.medium"]
  primary_worker_max_size       = 1
  primary_worker_min_size       = 1
  vpc_id                        = dependency.common.outputs.vpc_id
  vpc_private_subnets           = dependency.common.outputs.vpc_private_subnets
  vpc_public_subnets            = dependency.common.outputs.vpc_public_subnets
}

terraform {
  source = "../../../aws//eks"
}
