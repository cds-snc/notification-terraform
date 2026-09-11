data "aws_iam_policy_document" "scheduled_task_blazer_event_role_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["events.amazonaws.com"]
      type        = "Service"
    }

    # Prevent a confused-deputy: only allow our own account's EventBridge rules to assume this role.
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.account_id]
    }

    # Skipped when no schedules exist (cloudwatch_enabled = false) since the condition values can't be empty.
    dynamic "condition" {
      for_each = length(aws_cloudwatch_event_rule.blazer_run_checks) > 0 ? [1] : []
      content {
        test     = "ArnLike"
        variable = "aws:SourceArn"
        values   = [for rule in aws_cloudwatch_event_rule.blazer_run_checks : rule.arn]
      }
    }
  }
}

data "aws_iam_policy_document" "scheduled_task_blazer_event_role_cloudwatch_policy" {
  statement {
    effect  = "Allow"
    actions = ["ecs:RunTask"]
    #checkov:skip=CKV_AWS_111:Required to run scheduled Blazer ECS tasks
    resources = [aws_ecs_task_definition.blazer.arn]
  }

  # Required because the ecs_target in check_schedules.tf sets task tags, which makes
  # ECS require ecs:TagResource on the caller for every RunTask invocation.
  # Scoped to the task ARN (not the task-definition ARN) since RunTask tags the launched task.
  statement {
    effect    = "Allow"
    actions   = ["ecs:TagResource"]
    resources = ["arn:aws:ecs:${var.region}:${var.account_id}:task/${aws_ecs_cluster.blazer.name}/*"]
  }

  statement {
    effect  = "Allow"
    actions = ["iam:PassRole"]
    resources = [
      aws_iam_role.blazer_ecs_task.arn,
      aws_iam_role.blazer_execution_role.arn
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "scheduled_task_blazer_event_role" {
  provider           = aws.core_services
  name               = "blazer-scheduled-task-role-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.scheduled_task_blazer_event_role_assume_role_policy.json

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}

resource "aws_iam_role_policy" "scheduled_task_blazer_event_role_cloudwatch_policy" {
  provider = aws.core_services
  name     = "${aws_ecs_cluster.blazer.name}-ecs-scheduled-policy-${var.env}"
  role     = aws_iam_role.scheduled_task_blazer_event_role.id
  policy   = data.aws_iam_policy_document.scheduled_task_blazer_event_role_cloudwatch_policy.json
}
