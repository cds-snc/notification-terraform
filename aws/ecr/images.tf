#API Lambda Build and Push
resource "random_string" "api_suffix" {
  length  = 8
  special = false
}

resource "null_resource" "api_repo_clone" {

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "git clone 'https://github.com/cds-snc/notification-api.git' /var/tmp/notification-api"
  }
}

resource "null_resource" "build_api_docker_image" {

  depends_on = [null_resource.api_repo_clone]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "docker build -t ${aws_ecr_repository.api-lambda.repository_url}:${random_string.api_suffix.result} -f /var/tmp/notification-api/ci/Dockerfile.lambda /var/tmp/notification-api"
  }

}

resource "null_resource" "push_api_docker_image" {

  depends_on = [null_resource.build_api_docker_image]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.api-lambda.repository_url}:${random_string.api_suffix.result}"
  }

}

