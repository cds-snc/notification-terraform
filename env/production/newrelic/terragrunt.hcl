# Uses GitHub tags for release management
#
terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/newrelic?ref=v${get_env("INFRASTRUCTURE_VERSION")}" 
}

include {
  path = find_in_parent_folders()
}
