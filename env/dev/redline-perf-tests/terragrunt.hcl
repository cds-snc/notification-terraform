terraform {
  source = "${get_env("ENVIRONMENT") == "production" ? "git::https://github.com/cds-snc/notification-terraform//aws/redline-perf-tests?ref=v${get_env("INFRASTRUCTURE_VERSION")}" : "../../../aws//redline-perf-tests"}"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

inputs = {
  locust_target_host = include.root.inputs.perf_test_domain
}
