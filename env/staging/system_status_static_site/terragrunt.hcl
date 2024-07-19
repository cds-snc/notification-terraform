terraform {
  source = "../../../aws//system_status_static_site"
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../dns"]
}

dependency "dns" {

  config_path = "../dns"

  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs = {
    route53_zone_id = "Z04028033PLSHVOO9ZJ1Z"
  }
}

inputs = {
  env                                    = "staging"
  billing_tag_value                      = "notification-canada-ca-staging"
  status_cert_created                    = true
  route53_zone_id                        = dependency.dns.outputs.route53_zone_id
}
