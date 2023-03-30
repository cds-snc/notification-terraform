resource "aws_cloudwatch_log_group" "blazer" {
  name              = aws_ecs_cluster.blazer.name
  retention_in_days = 1827 # 5 years
}
