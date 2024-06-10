terraform {
  source = "../../../aws//system_status_static_site"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  env                                    = "staging"
  billing_tag_value                      = "notification-canada-ca-staging"
  status_cert_created                    = false
}
