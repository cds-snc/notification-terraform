terraform {
  source = "../../../aws//lambda-api"
}

include {
  path = find_in_parent_folders()
}

