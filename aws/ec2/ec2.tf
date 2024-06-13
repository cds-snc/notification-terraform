# Create EC2 instance
resource "aws_instance" "ec2_instance" {
  ami           = data.aws_ami.amazon_linux_2_ssm.id
  instance_type = "r5.2xlarge"
  subnet_id     = aws_subnet.private_subnet.id
  vpc_security_group_ids = [
    aws_security_group.instance_security_group.id,
  ]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  root_block_device {
    volume_size = 120
  }

}