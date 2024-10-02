terraform {
  source = "${get_env("ENVIRONMENT") == "production" ? "git::https://github.com/cds-snc/notification-terraform//aws/newrelic?ref=v${get_env("INFRASTRUCTURE_VERSION")}" : "../../../aws//newrelic"}"
}

include {
  path = find_in_parent_folders()
}
