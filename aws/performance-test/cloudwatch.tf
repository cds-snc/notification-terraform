resource "aws_cloudwatch_event_rule" "event_rule" {
  count               = var.cloudwatch_enabled ? 1 : 0
  name                = "perf_test_event_rule"
  schedule_expression = var.schedule_expression
  tags = {
    Name                  = "perf_test_cw_event_rule"
    CostCenter            = "notification-canada-ca-${var.env}"
  }
}


resource "aws_cloudwatch_event_target" "ecs_scheduled_task" {
  count          = var.cloudwatch_enabled ? 1 : 0
  rule           = aws_cloudwatch_event_rule.event_rule[0].name
  event_bus_name = aws_cloudwatch_event_rule.event_rule[0].event_bus_name
  arn            = aws_ecs_cluster.perf_test.arn
  role_arn       = aws_iam_role.scheduled_task_perf_test_event_role.arn

  ecs_target {
    launch_type         = "FARGATE"
    platform_version    = "1.4.0"
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.perf_test_task.arn
    network_configuration {
      subnets          = var.vpc_public_subnets
      security_groups  = [aws_security_group.perf_test.id]
      assign_public_ip = true
    }

    tags = {
      CostCenter = "notification-canada-ca-${var.env}"
    }
  }
}
