terraform {
  source = "../../../aws//common"
}

include {
  path = find_in_parent_folders()
}

# See QueueNames in
# https://github.com/cds-snc/notification-api/blob/master/app/config.py
