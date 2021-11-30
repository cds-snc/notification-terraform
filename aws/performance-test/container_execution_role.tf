###
# Container Execution Role
###
# Role that the Amazon ECS container agent and the Docker daemon can assume
###

resource "aws_iam_role" "container_execution_role" {
  name               = "container_execution_role"
  assume_role_policy = data.aws_iam_policy_document.container_execution_role.json
}

resource "aws_iam_role_policy_attachment" "ce_cs" {
  role       = aws_iam_role.container_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "perf_test_secretsmanager" {
  role       = aws_iam_role.container_execution_role.name
  policy_arn = aws_iam_policy.perf_test_secretsmanager.arn
}

###
# Policy Documents
###

data "aws_iam_policy_document" "container_execution_role" {
  statement {
    effect = "Allow"

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

resource "aws_iam_policy" "perf_test_secretsmanager" {
  name   = "PerfTestEcsTaskGetSecretValue"
  path   = "/"
  policy = data.aws_iam_policy_document.perf_test_secretsmanager.json
}

data "aws_iam_policy_document" "perf_test_secretsmanager" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    resources = [
      aws_secretsmanager_secret_version.perf_test_phone_number.arn,
      aws_secretsmanager_secret_version.perf_test_email.arn,
      aws_secretsmanager_secret_version.perf_test_domain.arn,
      aws_secretsmanager_secret_version.perf_test_auth_header.arn
    ]
  }
}
