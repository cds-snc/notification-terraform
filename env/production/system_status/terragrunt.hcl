dependencies {
  paths = ["../common", "../ecr", "../rds", "../eks"]
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs = {
    sns_alert_warning_arn  = ""
    sns_alert_critical_arn = ""
    vpc_private_subnets               = []
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
  }
}

dependency "ecr" {
  config_path = "../ecr"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    system_status_ecr_repository_url = ""
    system_status_ecr_arn = ""
  }
}

dependency "rds" {
  config_path = "../rds"
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    database_read_only_proxy_endpoint = ""
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  env                                    = "production"
  billing_tag_value                      = "notification-canada-ca-production"
  schedule_expression                    = "rate(1 minute)"
  sns_alert_warning_arn                  = dependency.common.outputs.sns_alert_warning_arn
  sns_alert_critical_arn                 = dependency.common.outputs.sns_alert_critical_arn
  system_status_ecr_repository_url       = dependency.ecr.outputs.system_status_ecr_repository_url
  system_status_ecr_arn                  = dependency.ecr.outputs.heartbeat_ecr_arn
  database_read_only_proxy_endpoint      = dependency.rds.outputs.database_read_only_proxy_endpoint
  eks_cluster_securitygroup              = dependency.eks.outputs.eks-cluster-securitygroup
  vpc_private_subnets                    = dependency.common.outputs.vpc_private_subnets
}

terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/system_status?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}
