# Pinpoint to SQS SMS Callbacks Build and Push

# Clone Lambda Repository
resource "null_resource" "lambda_repo_clone" {
  count = var.bootstrap ? 1 : 0
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "rm -rf /var/tmp/notification-lambdas && git clone 'https://github.com/cds-snc/notification-lambdas.git' /var/tmp/notification-lambdas"
  }
}

resource "null_resource" "build_pinpoint_to_sqs_sms_callbacks_docker_image" {
  count = var.bootstrap ? 1 : 0

  triggers = {
    always_run = "${timestamp()}"
  }

  depends_on = [
    null_resource.lambda_repo_clone
  ]

  provisioner "local-exec" {
    command = "cd /var/tmp/notification-lambdas/pinpointsmscallbacks && docker build -t ${aws_ecr_repository.pinpoint_to_sqs_sms_callbacks.repository_url}:bootstrap ."
  }

}

resource "null_resource" "push_pinpoint_to_sqs_sms_callbacks_docker_image" {
  count      = var.bootstrap ? 1 : 0
  depends_on = [null_resource.build_pinpoint_to_sqs_sms_callbacks_docker_image]

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.pinpoint_to_sqs_sms_callbacks.repository_url}:bootstrap"
  }

}
