include {
  path = find_in_parent_folders()
}

inputs = {
  billing_tag_value                           = "notification-canada-ca-staging"
  schedule_expression                         = "rate(1 minute)"
}

terraform {
  source = "../../../aws//heartbeat"
}
