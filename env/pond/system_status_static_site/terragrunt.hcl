terraform {
  source = "../../../aws//system_status_static_site"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  env                                    = "pond"
  billing_tag_value                      = "notification-canada-ca-pond"
  status_cert_created                    = true  
}
