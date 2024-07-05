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
    resources = [aws_ecs_task_definition.perf_test_task.arn]
  }
  statement {
    actions = ["iam:PassRole"]
    resources = [
      aws_iam_role.perf_test_ecs_task.arn,
      aws_iam_role.container_execution_role.arn
    ]
  }
}

resource "aws_iam_role" "scheduled_task_perf_test_event_role" {
  name               = "perf_test_scheduled_task_role"
  assume_role_policy = data.aws_iam_policy_document.scheduled_task_perf_test_event_role_assume_role_policy.json
  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_iam_role_policy" "scheduled_task_perf_test_event_role_cloudwatch_policy" {
  name   = "${aws_ecs_cluster.perf_test.name}-ecs-scheduled-policy"
  role   = aws_iam_role.scheduled_task_perf_test_event_role.id
  policy = data.aws_iam_policy_document.scheduled_task_perf_test_event_role_cloudwatch_policy.json
}
