terraform {
  source = "../../../aws//dev_only_kubernetes_fix"
}

include {
  path = find_in_parent_folders()
}
