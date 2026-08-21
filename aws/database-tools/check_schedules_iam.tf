data "aws_iam_policy_document" "scheduled_task_blazer_event_role_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["events.amazonaws.com"]
      type        = "Service"
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

  statement {
    effect  = "Allow"
    actions = ["iam:PassRole"]
    resources = [
      aws_iam_role.blazer_ecs_task.arn,
      aws_iam_role.blazer_execution_role.arn
    ]
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