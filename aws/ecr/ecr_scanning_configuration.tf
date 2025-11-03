resource "null_resource" "ecr_scan_v2_enable" {
  provisioner "local-exec" {
    command = "aws ecr put-account-setting --name BASIC_SCAN_TYPE_VERSION --value AWS_NATIVE"
  }
}