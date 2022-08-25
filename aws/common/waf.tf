resource "aws_wafv2_ip_set" "ip_blocklist" {
  name               = "ip_blocklist"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["40.50.60.70/32"]

  lifecycle {
    ignore_changes = all
  }
}
