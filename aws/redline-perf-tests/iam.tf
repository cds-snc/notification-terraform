###
# IAM — ECS task execution role and task role for Locust containers
###

###
# Task Execution Role
# Used by the ECS agent to pull images from ECR and write logs to CloudWatch.
###
resource "aws_iam_role" "locust_execution" {
  name = "locust-redline-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}

resource "aws_iam_role_policy_attachment" "locust_execution_managed" {
  role       = aws_iam_role.locust_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

###
# Task Role
# Assumed by the containers themselves.
# Grants the SSM Session Manager permissions required for `aws ecs execute-command`.
###
resource "aws_iam_role" "locust_task" {
  name = "locust-redline-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}

resource "aws_iam_role_policy" "locust_task_ecs_exec" {
  name = "locust-redline-ecs-exec"
  role = aws_iam_role.locust_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ssmmessages:CreateControlChannel",
        "ssmmessages:CreateDataChannel",
        "ssmmessages:OpenControlChannel",
        "ssmmessages:OpenDataChannel"
      ]
      Resource = "*"
    }]
  })
}
