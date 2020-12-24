locals {
    
    # To use the vpc_private_subnet within the same module, we must declare
    # a local. We can't reference an output defined by the same module.
    #
    # https://github.com/hashicorp/terraform/issues/17144
    # https://github.com/hashicorp/terraform/issues/26542
    vpc_private_subnets = aws_subnet.notification-canada-ca-private.*.id

}