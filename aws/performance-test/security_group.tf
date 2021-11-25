resource "aws_security_group" "perf_test" {
  name        = "perf_test"
  description = "Performance Test Security Group"

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
