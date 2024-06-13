terraform {
  source = "../../../aws//ec2"

}

include {
  path = find_in_parent_folders()
}
