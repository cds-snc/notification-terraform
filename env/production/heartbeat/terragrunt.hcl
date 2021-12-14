include {
  path = find_in_parent_folders()
}

inputs = {
  billing_tag_value                           = "notification-canada-ca-production"
  schedule_expression                         = "rate(1 minute)"
}

terraform {
    source = "git::https://github.com/cds-snc/notification-terraform//aws/heartbeat?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}
