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
  policy_arn = data.aws_iam_policy.ec2_container_service.arn
}

###
# Server Metrics Execution Role
###

resource "aws_iam_role" "server_metrics_container_execution_role" {
  name               = "server_metrics_container_execution_role"
  assume_role_policy = data.aws_iam_policy_document.container_execution_role.json
}

resource "aws_iam_role_policy_attachment" "server_metrics_ce_cs" {
  role       = aws_iam_role.server_metrics_container_execution_role.name
  policy_arn = data.aws_iam_policy.ec2_container_service.arn
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

data "aws_iam_policy" "ec2_container_service" {
  name = "AmazonEC2ContainerServiceforEC2Role"
}
