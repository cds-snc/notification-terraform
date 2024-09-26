terraform {
  source = "${get_env("ENVIRONMENT") == "production" ? "git::https://github.com/cds-snc/notification-terraform//aws/lambda-google-cidr?ref=v${get_env("INFRASTRUCTURE_VERSION")}" : "../../../aws//lambda-google-cidr"}"
}

dependencies {
  paths = ["../common", "../eks", "../ecr"]
}

dependency "common" {
  config_path = "../common"
}

dependency "ecr" {
  config_path = "../ecr"
}

dependency "eks" {
  config_path = "../eks"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init", "fmt", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    google_cidr_prefix_list_id      = ""
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  google_cidr_prefix_list_id         = dependency.eks.outputs.google_cidr_prefix_list_id
  google_cidr_ecr_repository_url     = dependency.ecr.outputs.google_cidr_ecr_repository_url
  google_cidr_ecr_arn                = dependency.ecr.outputs.google_cidr_ecr_arn
}
