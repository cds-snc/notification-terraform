resource "aws_cloudwatch_log_group" "perf_test_ecs_logs" {
  count             = var.cloudwatch_enabled ? 1 : 0
  name              = aws_ecs_cluster.perf_test.name
  retention_in_days = 14
}
