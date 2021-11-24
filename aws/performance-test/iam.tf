resource "aws_iam_role" "perf_test_ecs_task" {
  name               = "${aws_ecs_cluster.perf_test.name}-ecs-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}
# resource "aws_iam_policy" "wordpress_ecs_task_get_secret_value" {
#   name   = "WordpressEcsTaskGetSecretValue"
#   path   = "/"
#   policy = data.aws_iam_policy_document.wordpress_ecs_task_get_secret_value.json
# }

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

# resource "aws_iam_role_policy_attachment" "wordpress_ecs_task_get_secret_value_policy_attach" {
#   role       = aws_iam_role.perf_task_ecs_task.name
#   policy_arn = aws_iam_policy.wordpress_ecs_task_get_secret_value.arn
# }

resource "aws_iam_role_policy_attachment" "perf_test_ecs_task_get_ecr_image_policy_attach" {
  role       = aws_iam_role.perf_test_ecs_task.name
  policy_arn = aws_iam_policy.perf_test_ecs_task_get_ecr_image.arn
}

# resource "aws_iam_role_policy_attachment" "wordpress_ecs_task_efs_policy_attach" {
#   count = var.enable_efs ? 1 : 0

#   role       = aws_iam_role.perf_task_ecs_task.name
#   policy_arn = aws_iam_policy.wordpress_ecs_task_efs[0].arn
# }

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

# data "aws_iam_policy_document" "wordpress_ecs_task_get_secret_value" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "secretsmanager:GetSecretValue",
#     ]
#     resources = [
#       var.database_host_secret_arn,
#       var.database_name_secret_arn,
#       var.database_username_secret_arn,
#       var.database_password_secret_arn,
#       aws_secretsmanager_secret_version.list_manager_endpoint.arn,
#       aws_secretsmanager_secret_version.default_list_manager_api_key.arn,
#       aws_secretsmanager_secret_version.default_notify_api_key.arn,
#       aws_secretsmanager_secret_version.encryption_key.arn,
#       aws_secretsmanager_secret_version.s3_uploads_bucket.arn,
#       aws_secretsmanager_secret_version.s3_uploads_key.arn,
#       aws_secretsmanager_secret_version.s3_uploads_secret.arn,
#       aws_secretsmanager_secret_version.wordpress_auth_key.arn,
#       aws_secretsmanager_secret_version.wordpress_secure_auth_key.arn,
#       aws_secretsmanager_secret_version.wordpress_logged_in_key.arn,
#       aws_secretsmanager_secret_version.wordpress_nonce_key.arn,
#       aws_secretsmanager_secret_version.wordpress_auth_salt.arn,
#       aws_secretsmanager_secret_version.wordpress_secure_auth_salt.arn,
#       aws_secretsmanager_secret_version.wordpress_logged_in_salt.arn,
#       aws_secretsmanager_secret_version.wordpress_nonce_salt.arn
#     ]
#   }
# }

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

