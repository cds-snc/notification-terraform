terraform {
  source = "../../../aws//common"

  before_hook "get-admin" {
    commands     = ["apply", "plan"]
    execute      = ["git", "clone", "https://github.com/cds-snc/notification-admin.git", "/var/tmp/notification-admin"]
    run_on_error = true

  }

  after_hook "cleanup-admin" {
    commands     = ["apply", "plan"]
    execute      = ["rm", "-rfd", "/var/tmp/notification-admin"]
    run_on_error = true
  }  
}

include {
  path = find_in_parent_folders()
}

inputs = {
}

# See QueueNames in
# https://github.com/cds-snc/notification-api/blob/master/app/config.py
