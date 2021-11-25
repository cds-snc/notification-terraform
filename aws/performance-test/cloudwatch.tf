resource "aws_cloudwatch_event_rule" "event_rule" {
  name                = "perf_test_event_rule"
  schedule_expression = var.schedule_expression
  tags = {
    Name = "perf_test_cw_event_rule"
  }
}


resource "aws_cloudwatch_event_target" "ecs_scheduled_task" {
  rule           = aws_cloudwatch_event_rule.event_rule.name
  event_bus_name = aws_cloudwatch_event_rule.event_rule.event_bus_name
  arn            = aws_ecs_cluster.perf_test.arn
  role_arn       = aws_ecs_task_definition.perf_test_task.task_role_arn

  ecs_target {
    launch_type         = "FARGATE"
    platform_version    = "1.4.0"
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.perf_test_task.arn

    network_configuration {
      subnets         = var.vpc_public_subnets
      security_groups = [aws_security_group.perf_test.id]
    }
  }
}

resource "aws_cloudwatch_log_metric_filter" "ecs_task_error_metric" {
  name           = "EcsTaskError-${var.name}"
  pattern        = "Error"
  log_group_name = aws_cloudwatch_log_group.perf_test_ecs_logs.name

  metric_transformation {
    name      = "EcsTaskError-${var.name}"
    namespace = "perf_test_metrics"
    value     = "1"
  }
}
