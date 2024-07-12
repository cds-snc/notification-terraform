resource "aws_iam_role" "blazer_ecs_task" {
  name               = "${aws_ecs_cluster.blazer.name}-ecs-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_iam_role_policy_attachment" "blazer_ecs_task_policy_attach" {
  role       = aws_iam_role.blazer_ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
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

resource "aws_iam_policy" "blazer_task_role_policy" {
  name   = "blazer_task_role_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.blazer_task_role_actions.json
}

resource "aws_iam_role_policy_attachment" "blazer_task_role_actions" {
  role       = aws_iam_role.blazer_ecs_task.name
  policy_arn = aws_iam_policy.blazer_task_role_policy.arn
}

data "aws_iam_policy_document" "blazer_task_role_actions" {
  statement {

    effect = "Allow"

    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }

  statement {

    effect = "Allow"

    actions = [
      "ssm:DescribeParameters",
      "ssm:GetParameters",
    ]
    resources = [
      aws_ssm_parameter.sqlalchemy_database_reader_uri.arn,
      aws_ssm_parameter.db_tools_environment_variables.arn,
      aws_ssm_parameter.notify_o11y_google_oauth_client_id.arn,
      aws_ssm_parameter.notify_o11y_google_oauth_client_secret.arn
    ]
  }
}
