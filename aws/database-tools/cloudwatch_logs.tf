removed {
  from = aws_cloudwatch_log_group.blazer

  lifecycle {
    destroy = false
  }
}