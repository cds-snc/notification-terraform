dependencies {
  paths = ["../common", "../eks"]
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    kms_arn = ""
    vpc_private_subnets = [
      "subnet-001e585d12cce4d1e",
      "subnet-08de34a9e1a7458dc",
      "subnet-0af8b8402f1d605ff",
    ]
    sns_alert_general_arn = ""
  }
}

dependency "eks" {
  config_path = "../eks"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    eks-cluster-securitygroup                 = "sg-0e2c3ef6c5c75b74c"
    sentinel_forwarder_cloudwatch_lambda_arn  = "arn:aws:lambda:ca-central-1:123456789012:function:sentinel-cloud-watch-forwarder"
    sentinel_forwarder_cloudwatch_lambda_name = "sentinel-cloud-watch-forwarder"
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  eks_cluster_securitygroup = dependency.eks.outputs.eks-cluster-securitygroup
  kms_arn                   = dependency.common.outputs.kms_arn
  vpc_private_subnets       = dependency.common.outputs.vpc_private_subnets
  sns_alert_general_arn     = dependency.common.outputs.sns_alert_general_arn
  sentinel_forwarder_cloudwatch_lambda_arn  = dependency.eks.outputs.sentinel_forwarder_cloudwatch_lambda_arn
  sentinel_forwarder_cloudwatch_lambda_name = dependency.eks.outputs.sentinel_forwarder_cloudwatch_lambda_name
}

terraform {
  source = "../../../aws//rds"
}
