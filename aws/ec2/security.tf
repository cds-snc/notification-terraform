# Create a security group for the EC2 instance
resource "aws_security_group" "instance_security_group" {
  name_prefix = "instance-sg"
  vpc_id      = aws_vpc.vpc.id
  description = "security group for the EC2 instance"

  # Allow outbound HTTPS traffic
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS outbound traffic"
  }

  tags = {
    Name = "EC2 Instance security group"
  }
}

# Security group for VPC Endpoints
resource "aws_security_group" "vpc_endpoint_security_group" {
  name_prefix = "vpc-endpoint-sg"
  vpc_id      = aws_vpc.vpc.id
  description = "security group for VPC Endpoints"

  # Allow inbound HTTPS traffic
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
    description = "Allow HTTPS traffic from VPC"
  }

  tags = {
    Name = "VPC Endpoint security group"
  }
}