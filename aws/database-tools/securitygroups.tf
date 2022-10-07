resource "aws_security_group" "blazer" {
  name        = "blazer"
  description = "Allow inbound traffic to internal service"
  vpc_id      = var.vpc_id

  egress {
    description = "Access to internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Access to internal service"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    self        = true
    cidr_blocks = ["0.0.0.0/0"]
  }
}
