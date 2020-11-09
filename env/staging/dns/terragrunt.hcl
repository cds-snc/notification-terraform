terraform {
  source = "../../../aws//dns"
}

include {
  path = find_in_parent_folders()
}