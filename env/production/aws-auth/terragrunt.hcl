terraform {
  source = "../../../aws//aws-auth"
}

include {
  path = find_in_parent_folders()
}
