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
      "subnet-001e585d12cce4d1e",
      "subnet-08de34a9e1a7458dc",
      "subnet-0af8b8402f1d605ff",
    ]
    vpc_private_subnets_separate_reader_db = "subnet-0af8b8402f1d60523"
    sns_alert_general_arn = ""
  }
  mock_outputs_merge_with_state = true
}

dependency "eks" {
  config_path = "../eks"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    eks-cluster-securitygroup = "sg-0e2c3ef6c5c75b74c"
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  eks_cluster_securitygroup              = dependency.eks.outputs.eks-cluster-securitygroup
  kms_arn                                = dependency.common.outputs.kms_arn
  rds_instance_count                     = 3
  rds_instance_type                      = "db.r6g.large"
  vpc_private_subnets                    = dependency.common.outputs.vpc_private_subnets
  vpc_private_subnets_separate_reader_db = dependency.common.outputs.vpc_private_subnets_separate_reader_db
  sns_alert_general_arn                  = dependency.common.outputs.sns_alert_general_arn
  rds_database_name                      = "NotificationCanadaCastaging"
}

terraform {
  source = "../../../aws//rds"
}
