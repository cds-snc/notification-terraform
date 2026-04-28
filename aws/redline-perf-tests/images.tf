/*
This follows the same Terraform-driven Docker bootstrap pattern used in the
shared ECR modules. When bootstrap is enabled, Terraform builds the local
Locust image from this repo and pushes a :bootstrap tag to ECR so ECS can use
it immediately in a brand-new environment.
*/

resource "null_resource" "build_locust_redline_docker_image" {

  triggers = {
    always_run = timestamp()
  }

  depends_on = [
    aws_ecr_repository.locust_redline
  ]

  provisioner "local-exec" {
    command = "cd locust && docker build -t ${aws_ecr_repository.locust_redline.repository_url}:bootstrap ."
  }
}

resource "null_resource" "push_locust_redline_docker_image" {

  depends_on = [
    null_resource.build_locust_redline_docker_image
  ]
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.locust_redline.repository_url}:bootstrap"
  }
}
