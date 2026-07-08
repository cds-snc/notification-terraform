resource "aws_cloudwatch_log_group" "perf_test_ecs_logs" {
  provider          = aws.core_services
  count             = var.cloudwatch_enabled ? 1 : 0
  name              = aws_ecs_cluster.perf_test.name
  retention_in_days = var.log_retention_period_days
}
