dependencies {
  paths = ["../common"]
}

terraform {
  source = "../../../aws//newrelic"
}

include {
  path = find_in_parent_folders()
}
