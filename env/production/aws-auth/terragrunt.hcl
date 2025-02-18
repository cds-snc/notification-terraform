terraform {
  source = "${get_env("ENVIRONMENT") == "production" ? "git::https://github.com/cds-snc/notification-terraform//aws/aws-auth?ref=v${get_env("INFRASTRUCTURE_VERSION")}" : "../../../aws//aws-auth"}"
}

include {
  path = find_in_parent_folders()
}


