# SES Receiving Emails Build and Push

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

resource "null_resource" "build_ses_receiving_emails_docker_image" {
  count = var.bootstrap ? 1 : 0

  triggers = {
    always_run = "${timestamp()}"
  }

  depends_on = [
    null_resource.lambda_repo_clone
  ]

  provisioner "local-exec" {
    command = "cd /var/tmp/notification-lambdas/ && docker build -t ${aws_ecr_repository.ses_receiving_emails.repository_url}:bootstrap -f /var/tmp/notification-lambdas/sesreceivingemails/Dockerfile ."
  }

}

resource "null_resource" "push_ses_receiving_emails_docker_image" {
  count      = var.bootstrap ? 1 : 0
  depends_on = [null_resource.build_ses_receiving_emails_docker_image]

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.ses_receiving_emails.repository_url}:bootstrap"
  }

}