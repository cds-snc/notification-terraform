data "aws_iam_policy_document" "scheduled_task_perf_test_event_role_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["events.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "scheduled_task_perf_test_event_role_cloudwatch_policy" {
  statement {
    effect  = "Allow"
    actions = ["ecs:RunTask"]
    #checkov:skip=CKV_AWS_111:for testing only
    resources = [
      "arn:aws:ecs:${var.region}:${var.account_id}:task-definition/${aws_ecs_cluster.perf_test.name}:*"
    ]

    condition {
      test     = "ArnEquals"
      variable = "ecs:cluster"
      values   = [aws_ecs_cluster.perf_test.arn]
    }
  }
  statement {
    effect  = "Allow"
    actions = ["iam:PassRole"]
    resources = [
      aws_iam_role.perf_test_ecs_task.arn,
      aws_iam_role.container_execution_role.arn
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "scheduled_task_perf_test_event_role" {
  provider           = aws.core_services
  name               = "perf_test_scheduled_task_role"
  assume_role_policy = data.aws_iam_policy_document.scheduled_task_perf_test_event_role_assume_role_policy.json
  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}

resource "aws_iam_role_policy" "scheduled_task_perf_test_event_role_cloudwatch_policy" {
  provider = aws.core_services
  name     = "${aws_ecs_cluster.perf_test.name}-ecs-scheduled-policy"
  role     = aws_iam_role.scheduled_task_perf_test_event_role.id
  policy   = data.aws_iam_policy_document.scheduled_task_perf_test_event_role_cloudwatch_policy.json
}
