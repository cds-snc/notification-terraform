terraform {
  source = "${get_env("ENVIRONMENT") == "production" ? "git::https://github.com/cds-snc/notification-terraform//aws/github?ref=v${get_env("INFRASTRUCTURE_VERSION")}" : "../../../aws//github"}"
}

include {
  path = find_in_parent_folders()
}

