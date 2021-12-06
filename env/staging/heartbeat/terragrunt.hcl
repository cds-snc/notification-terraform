include {
  path = find_in_parent_folders()
}

inputs = {
  billing_tag_key                             = "CostCenter"
  billing_tag_value                           = "notification-canada-ca-staging"
  schedule_expression                         = "cron(*/1 * * * *)"
}

terraform {
  source = "../../../aws/heartbeat"
}
