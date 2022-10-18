data "aws_subnet" "private_subnet" {
  for_each = toset(var.vpc_private_subnets)
  id       = each.value
}


resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = var.database-tools-securitygroup
  network_interface_id = aws_ecs_service.blazer.network_interface_id
}
