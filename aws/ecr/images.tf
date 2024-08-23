/*
This is a dirty hack and exists only to bootstrap new environments. 
Lambda Functions will not build unless the docker image is specified before hand. 
In a new environment, these images would not exist in the ECR yet and thus the build fails.
This code pulls the source code of the other repositories, builds the images, and pushes to ECR if the bootstrap variable is set to true.
*/

#Notify Admin Build and Push

resource "null_resource" "admin_repo_clone" {
  count = var.bootstrap ? 1 : 0
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "git clone 'https://github.com/cds-snc/notification-admin.git' /var/tmp/notification-admin"
  }
}

resource "null_resource" "build_admin_docker_image" {
  count = var.bootstrap ? 1 : 0
  depends_on = [
    null_resource.admin_repo_clone
  ]

  provisioner "local-exec" {
    command = "cd /var/tmp/notification-admin/ && docker build -t ${aws_ecr_repository.notify_admin[0].repository_url}:bootstrap -f /var/tmp/notification-admin/ci/Dockerfile.lambda ."
  }

}

resource "null_resource" "push_admin_docker_image" {
  count      = var.bootstrap ? 1 : 0
  depends_on = [null_resource.build_admin_docker_image]

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.notify_admin[0].repository_url}:bootstrap"
  }

}


#API Lambda Build and Push

resource "null_resource" "api_repo_clone" {
  count = var.bootstrap ? 1 : 0
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "git clone 'https://github.com/cds-snc/notification-api.git' /var/tmp/notification-api"
  }
}

resource "null_resource" "build_api_docker_image" {
  count = var.bootstrap ? 1 : 0
  depends_on = [
    null_resource.api_repo_clone
  ]

  provisioner "local-exec" {
    command = "cd /var/tmp/notification-api/ && docker build -t ${aws_ecr_repository.api-lambda.repository_url}:bootstrap -f /var/tmp/notification-api/ci/Dockerfile.lambda ."
  }

}

resource "null_resource" "push_api_docker_image" {
  count      = var.bootstrap ? 1 : 0
  depends_on = [null_resource.build_api_docker_image]

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.api-lambda.repository_url}:bootstrap"
  }

}

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

#Heartbeat Build and Push

resource "null_resource" "build_heartbeat_docker_image" {
  count = var.bootstrap ? 1 : 0
  depends_on = [
    null_resource.lambda_repo_clone
  ]

  provisioner "local-exec" {
    command = "cd /var/tmp/notification-lambdas/heartbeat && docker build -t ${aws_ecr_repository.heartbeat.repository_url}:bootstrap -f /var/tmp/notification-lambdas/heartbeat/Dockerfile ."
  }

}

resource "null_resource" "push_heartbeat_docker_image" {
  count      = var.bootstrap ? 1 : 0
  depends_on = [null_resource.build_heartbeat_docker_image]

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.heartbeat.repository_url}:bootstrap"
  }

}

#Google-Cidr Build and Push

resource "null_resource" "build_google_cidr_docker_image" {
  count = var.bootstrap ? 1 : 0
  depends_on = [
    null_resource.lambda_repo_clone
  ]

  provisioner "local-exec" {
    command = "cd /var/tmp/notification-lambdas/google-cidr && docker build -t ${aws_ecr_repository.google-cidr.repository_url}:bootstrap -f /var/tmp/notification-lambdas/google-cidr/Dockerfile ."
  }

}

resource "null_resource" "push_google_cidr_docker_image" {
  count      = var.bootstrap ? 1 : 0
  depends_on = [null_resource.build_google_cidr_docker_image]

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.google-cidr.repository_url}:bootstrap"
  }

}

# SES Receiving Emails Build and Push

resource "null_resource" "build_ses_receiving_emails_docker_image" {
  count = var.bootstrap ? 1 : 0
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

# SES Receiving Emails Build and Push

resource "null_resource" "build_ses_to_sqs_email_callbacks_docker_image" {
  count = var.bootstrap ? 1 : 0
  depends_on = [
    null_resource.lambda_repo_clone
  ]

  provisioner "local-exec" {
    command = "cd /var/tmp/notification-lambdas/ && docker build -t ${aws_ecr_repository.ses_to_sqs_email_callbacks.repository_url}:bootstrap -f /var/tmp/notification-lambdas/sesemailcallbacks/Dockerfile ."
  }

}

resource "null_resource" "push_ses_to_sqs_email_callbacks_docker_image" {
  count      = var.bootstrap ? 1 : 0
  depends_on = [null_resource.build_ses_to_sqs_email_callbacks_docker_image]

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.ses_to_sqs_email_callbacks.repository_url}:bootstrap"
  }

}

# SNS to SQS Queue Build and Push

resource "null_resource" "build_sns_to_sqs_sms_callbacks_docker_image" {
  count = var.bootstrap ? 1 : 0
  depends_on = [
    null_resource.lambda_repo_clone
  ]

  provisioner "local-exec" {
    command = "cd /var/tmp/notification-lambdas/ && docker build -t ${aws_ecr_repository.sns_to_sqs_sms_callbacks.repository_url}:bootstrap -f /var/tmp/notification-lambdas/sesemailcallbacks/Dockerfile ."
  }

}

resource "null_resource" "push_sns_to_sqs_sms_callbacks_docker_image" {
  count      = var.bootstrap ? 1 : 0
  depends_on = [null_resource.build_sns_to_sqs_sms_callbacks_docker_image]

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.sns_to_sqs_sms_callbacks.repository_url}:bootstrap"
  }

}

#System status Build and Push

resource "null_resource" "build_system_status_docker_image" {
  count = var.bootstrap ? 1 : 0
  depends_on = [
    null_resource.lambda_repo_clone
  ]

  provisioner "local-exec" {
    command = "cd /var/tmp/notification-lambdas/system_status && docker build -t ${aws_ecr_repository.system_status.repository_url}:bootstrap -f /var/tmp/notification-lambdas/system_status/Dockerfile ."
  }
}

resource "null_resource" "push_system_status_docker_image" {
  count      = var.bootstrap ? 1 : 0
  depends_on = [null_resource.build_system_status_docker_image]

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.system_status.repository_url}:bootstrap"
  }

}

# Pinpoint to SQS Queue Build and Push

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
