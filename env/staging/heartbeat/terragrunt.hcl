include {
  path = find_in_parent_folders()
}

inputs = {
  billing_tag_value                           = "notification-canada-ca-staging"
  schedule_expression                         = "cron(* * * * ? *)"
}

terraform {
  source = "../../../aws//heartbeat"
}
