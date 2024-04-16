/*
This is a dirty hack and exists only to bootstrap new environments. 
Lambda Functions will not build unless the docker image is specified before hand. 
In a new environment, these images would not exist in the ECR yet and thus the build fails.
This code pulls the source code of the other repositories, builds the images, and pushes to ECR if the bootstrap variable is set to true.
*/

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

resource "null_resource" "build_pinpoint_to_sqs_sms_callbacks_docker_image" {
  count = var.bootstrap ? 1 : 0
  depends_on = [
    null_resource.lambda_repo_clone
  ]

  provisioner "local-exec" {
    command = "docker build -t ${aws_ecr_repository.pinpoint_to_sqs_sms_callbacks.repository_url}:bootstrap -f /var/tmp/notification-lambdas/pinpointsmscallbacks/Dockerfile /var/tmp/notification-lambdas"
  }
}

resource "null_resource" "push_pinpoint_to_sqs_sms_callbacks_docker_image" {
  count      = var.bootstrap ? 1 : 0
  depends_on = [null_resource.build_pinpoint_to_sqs_sms_callbacks_docker_image]

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.pinpoint_to_sqs_sms_callbacks.repository_url}:bootstrap"
  }
}
