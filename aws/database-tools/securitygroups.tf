data "aws_subnet" "private_subnet" {
  for_each = toset(var.vpc_private_subnets)
  id       = each.value
}
