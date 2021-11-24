dependencies {
  paths = ["../common", "../eks"]
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs = {
    kms_arn = ""
    vpc_private_subnets = [
      "",
      "",
      "",
    ]
    sns_alert_general_arn = ""
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

include {
  path = find_in_parent_folders()
}

inputs = {
  env                         = "staging"
  api_image_tag               = "latest"
  eks_cluster_securitygroup   = dependency.eks.outputs.eks-cluster-securitygroup
  vpc_private_subnets         = dependency.common.outputs.vpc_private_subnets
  aws_pinpoint_region         = "ca-central-1"
  low_demand_min_concurrency  = 1
  low_demand_max_concurrency  = 5
  high_demand_min_concurrency = 1
  high_demand_max_concurrency = 10
  billing_tag_key             = "CostCentre"
  billing_tag_value           = "notification-canada-ca-staging"
}

terraform {
  source = "../../../aws//performance-test"
}
