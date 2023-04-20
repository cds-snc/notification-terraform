dependencies {
  paths = ["../common", "../eks"]
}

dependency "common" {
  config_path = "../common"
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
  billing_tag_value                  = "notification-canada-ca-staging"
  google_cidr_schedule_expression    = "rate(1 day)"
  google_cidr_prefix_list_id         = dependency.eks.outputs.google_cidr_prefix_list_id
}

terraform {
  source = "../../../aws//lambda-google-cidr"
}
