terraform {
  source = "${get_env("ENVIRONMENT") == "production" ? "git::https://github.com/cds-snc/notification-terraform//aws/vpn?ref=v${get_env("INFRASTRUCTURE_VERSION")}" : "../../../aws//vpn"}"
}

dependencies {
  paths = ["../common", "../eks"]
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    vpc_id = "vpc-0c7d18c0c51b28b61"
    subnet_ids = [
      "subnet-0cecd9e634daf82d3",
      "subnet-0c7d18c0c51b28b61",
      "subnet-0c91f7c6b8211904b",
    ]
    subnet_cidr_blocks = [
      "10.0.0.0/24",
      "10.0.1.0/24",
      "10.0.2.0/24",
      "10.0.32.0/19",
      "10.0.64.0/19",
      "10.0.96.0/19",
    ]    
  }
}

dependency "eks" {
  config_path = "../eks"

  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show", "pull"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    eks_securitygroup_rds = "sg-0a7094caf5b990eb3"
    eks_cluster_securitygroup_id = "sg-0a7094caf5b990eb3"
    eks_application_log_group = ""
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  vpc_id                                    = dependency.common.outputs.vpc_id
  subnet_ids                                = dependency.common.outputs.subnet_ids
  subnet_cidr_blocks                        = dependency.common.outputs.subnet_cidr_blocks  
  eks_securitygroup_rds                     = dependency.eks.outputs.eks_securitygroup_rds
  eks_cluster_securitygroup_id              = dependency.eks.outputs.eks_cluster_securitygroup_id
  eks_application_log_group                 = dependency.eks.outputs.eks_application_log_group
}
