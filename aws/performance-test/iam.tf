resource "aws_iam_role" "perf_test_ecs_task" {
  name               = "${aws_ecs_cluster.perf_test.name}-ecs-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}

resource "aws_iam_policy" "perf_test_ecs_task_get_ecr_image" {
  name   = "PerformanceTestEcsTaskGetEcrImage"
  path   = "/"
  policy = data.aws_iam_policy_document.perf_test_ecs_task_get_ecr_image.json
}


resource "aws_iam_role_policy_attachment" "perf_test_ecs_task_policy_attach" {
  role       = aws_iam_role.perf_test_ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "perf_test_ecs_task_ec2_policy_attach" {
  role       = aws_iam_role.perf_test_ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "perf_test_ecs_task_get_ecr_image_policy_attach" {
  role       = aws_iam_role.perf_test_ecs_task.name
  policy_arn = aws_iam_policy.perf_test_ecs_task_get_ecr_image.arn
}

resource "aws_iam_role_policy_attachment" "perf_test_s3_attach" {
  role       = aws_iam_role.perf_test_ecs_task.name
  policy_arn = aws_iam_policy.notify_performance_test_s3.arn
}

data "aws_iam_policy_document" "ecs_task_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "perf_test_ecs_task_get_ecr_image" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForlayer",
      "ecr:BatchGetImage"
    ]
    resources = [
      aws_ecr_repository.performance-test.arn
    ]
  }
}
