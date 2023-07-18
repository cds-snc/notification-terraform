terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/dns?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}

include {
  path = find_in_parent_folders()
}

