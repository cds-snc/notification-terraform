resource "aws_iam_role" "perf_test_ecs_task" {
  provider           = aws.core_services
  name               = "${aws_ecs_cluster.perf_test.name}-ecs-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}

resource "aws_iam_role_policy_attachment" "perf_test_ecs_task_policy_attach" {
  provider   = aws.core_services
  role       = aws_iam_role.perf_test_ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "perf_test_s3_attach" {
  provider   = aws.core_services
  role       = aws_iam_role.perf_test_ecs_task.name
  policy_arn = aws_iam_policy.notify_performance_test_s3.arn
}

data "aws_iam_policy_document" "ecs_task_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
