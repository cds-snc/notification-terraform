terraform {
  source = "${get_env("ENVIRONMENT") == "production" ? "git::https://github.com/cds-snc/notification-terraform//aws/dev_only_kubernetes_fix?ref=v${get_env("INFRASTRUCTURE_VERSION")}" : "../../../aws//dev_only_kubernetes_fix"}"
}

include {
  path = find_in_parent_folders()
}


