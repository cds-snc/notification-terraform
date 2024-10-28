data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  # Canonical Owner ID
  # https://documentation.ubuntu.com/aws/en/latest/aws-how-to/instances/find-ubuntu-images/#ownership-verification
  owners = ["099720109477"]
}

# Create EC2 instance
resource "aws_instance" "ec2_instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "r5.4xlarge"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.private_subnet.id
  vpc_security_group_ids = [
    aws_security_group.instance_security_group.id,
  ]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_size = 120
  }

}
