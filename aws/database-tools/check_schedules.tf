locals {
  blazer_check_schedules = var.cloudwatch_enabled ? {
    "5-minutes" = {
      expression = "rate(5 minutes)"
      schedule   = "5 minutes"
    }
    "1-hour" = {
      expression = "rate(1 hour)"
      schedule   = "1 hour"
    }
    "1-day" = {
      expression = "cron(30 7 * * ? *)"
      schedule   = "1 day"
    }
  } : {}
}

resource "aws_cloudwatch_event_rule" "blazer_run_checks" {
  provider            = aws.core_services
  for_each            = local.blazer_check_schedules
  name                = "blazer-run-checks-${each.key}"
  schedule_expression = each.value.expression

  tags = {
    Name                  = "blazer-run-checks-${each.key}"
    (var.billing_tag_key) = var.billing_tag_value
  }
}

resource "aws_cloudwatch_event_target" "blazer_run_checks" {
  provider = aws.core_services
  for_each = local.blazer_check_schedules

  rule           = aws_cloudwatch_event_rule.blazer_run_checks[each.key].name
  event_bus_name = aws_cloudwatch_event_rule.blazer_run_checks[each.key].event_bus_name
  arn            = aws_ecs_cluster.blazer.arn
  role_arn       = aws_iam_role.scheduled_task_blazer_event_role.arn

  input = jsonencode({
    containerOverrides = [
      {
        name    = "blazer"
        command = ["bundle", "exec", "rake", "blazer:run_checks"]
        environment = [
          {
            name  = "SCHEDULE"
            value = each.value.schedule
          }
        ]
      }
    ]
  })

  ecs_target {
    launch_type         = "FARGATE"
    platform_version    = "1.4.0"
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.blazer.arn
    network_configuration {
      subnets          = var.vpc_private_subnets
      security_groups  = [var.database-tools-securitygroup]
      assign_public_ip = false
    }

    tags = {
      (var.billing_tag_key) = var.billing_tag_value
    }
  }
}