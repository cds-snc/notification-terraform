# Clone Lambda Repository
resource "null_resource" "lambda_repo_clone" {
  count = var.bootstrap ? 1 : 0
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "git clone 'https://github.com/cds-snc/notification-lambdas.git' /var/tmp/notification-lambdas"
  }
}

# Blazer Build and Push

resource "null_resource" "build_blazer_docker_image" {
  count = var.bootstrap ? 1 : 0
  depends_on = [
    null_resource.lambda_repo_clone
  ]

  provisioner "local-exec" {
    command = "cd /var/tmp/notification-lambdas/blazer/ && docker build -t ${aws_ecr_repository.blazer.repository_url}:bootstrap"
  }

}

resource "null_resource" "push_blazer_docker_image" {
  count      = var.bootstrap ? 1 : 0
  depends_on = [null_resource.build_blazer_docker_image]

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.blazer.repository_url}:bootstrap"
  }

}