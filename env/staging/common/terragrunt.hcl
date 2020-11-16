terraform {
  source = "../../../aws//common"
}

include {
  path = find_in_parent_folders()
}

dependency "eks" {
  config_path = "../eks"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    alb_arn_suffix             = ""
    eks_cluster_log_group_name = ""
  }
}

inputs = {
  sns_monthly_spend_limit    = 1
  alb_arn_suffix             = dependency.eks.outputs.alb_arn_suffix
  eks_cluster_log_group_name = dependency.eks.outputs.eks_cluster_log_group_name
}
