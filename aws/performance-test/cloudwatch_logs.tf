resource "aws_cloudwatch_log_group" "perf_test_ecs_logs" {
  name              = aws_ecs_cluster.perf_test.name
  retention_in_days = 14
}
