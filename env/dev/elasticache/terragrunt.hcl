terraform {
  source = "${get_env("ENVIRONMENT") == "production" ? "git::https://github.com/cds-snc/notification-terraform//aws/elasticache?ref=v${get_env("INFRASTRUCTURE_VERSION")}" : "../../../aws//elasticache"}"
}

dependencies {
  paths = ["../common", "../eks"]
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "init"]
  mock_outputs = {
    vpc_id = ""
    vpc_private_subnets = [
      "subnet-001e585d12cce4d1e",
      "subnet-08de34a9e1a7458dc",
      "subnet-0af8b8402f1d605ff",
    ]
    sns_alert_warning_arn  = ""
    sns_alert_critical_arn = ""
    kms_arn               = ""
  }
}

dependency "eks" {
  config_path = "../eks"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "init"]
  mock_outputs = {
    eks-cluster-securitygroup = "sg-0e2c3ef6c5c75b74c"
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  eks_cluster_securitygroup              = dependency.eks.outputs.eks-cluster-securitygroup
  vpc_private_subnets                    = dependency.common.outputs.vpc_private_subnets
  sns_alert_warning_arn                  = dependency.common.outputs.sns_alert_warning_arn
  sns_alert_critical_arn                 = dependency.common.outputs.sns_alert_critical_arn
  vpc_id                                 = dependency.common.outputs.vpc_id
  kms_arn                                = dependency.common.outputs.kms_arn  
}
