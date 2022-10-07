###
# Container Execution Role
###
# Role that the Amazon ECS container agent and the Docker daemon can assume
###

resource "aws_iam_role" "blazer_execution_role" {
  name               = "blazer_execution_role"
  assume_role_policy = data.aws_iam_policy_document.blazer_execution_role.json
}

resource "aws_iam_role_policy_attachment" "ce_cs" {
  role       = aws_iam_role.blazer_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

###
# Policy Documents
###

data "aws_iam_policy_document" "blazer_execution_role" {
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
    ]
  }
}
