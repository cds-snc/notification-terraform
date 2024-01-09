include {
  path = find_in_parent_folders()
}

inputs = {
  env                                    = "production"
  billing_tag_value                      = "notification-canada-ca-production"
  status_cert_created                    = true    
}

terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/system_status_static_site?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}