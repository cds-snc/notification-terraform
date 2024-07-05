terraform {
  source = "../../../aws//system_status_static_site"
}

include {
  path = find_in_parent_folders()
}
