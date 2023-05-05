#Notify Admin Build and Push
resource "random_string" "admin_suffix" {
  length  = 8
  special = false
}

resource "null_resource" "admin_repo_clone" {

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "git clone 'https://github.com/cds-snc/notification-admin.git' /var/tmp/notification-admin"
  }
}

resource "null_resource" "build_admin_docker_image" {

  depends_on = [
    null_resource.admin_repo_clone,
    random_string.admin_suffix
  ]

  provisioner "local-exec" {
    command = "docker build -t ${aws_ecr_repository.notify_admin.repository_url}:${random_string.admin_suffix.result} -f /var/tmp/notification-admin/ci/Dockerfile.lambda /var/tmp/notification-admin/"
  }

}

resource "null_resource" "push_admin_docker_image" {

  depends_on = [null_resource.build_admin_docker_image]

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.notify_admin.repository_url}:${random_string.admin_suffix.result}"
  }

}


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

  depends_on = [
    null_resource.api_repo_clone,
    random_string.api_suffix
  ]

  provisioner "local-exec" {
    command = "docker build -t ${aws_ecr_repository.api-lambda.repository_url}:${random_string.api_suffix.result} -f /var/tmp/notification-api/ci/Dockerfile.lambda /var/tmp/notification-api"
  }

}

resource "null_resource" "push_api_docker_image" {

  depends_on = [null_resource.build_api_docker_image]

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.api-lambda.repository_url}:${random_string.api_suffix.result}"
  }

}

# Clone Lambda Repository
resource "null_resource" "lambda_repo_clone" {

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "git clone 'https://github.com/cds-snc/notification-lambdas.git' /var/tmp/notification-lambdas"
  }
}

#Heartbeat Build and Push
resource "random_string" "heartbeat_suffix" {
  length  = 8
  special = false
}

resource "null_resource" "build_heartbeat_docker_image" {

  depends_on = [
    null_resource.lambda_repo_clone,
    random_string.heartbeat_suffix
  ]

  provisioner "local-exec" {
    command = "docker build -t ${aws_ecr_repository.heartbeat.repository_url}:${random_string.heartbeat_suffix.result} -f /var/tmp/notification-lambdas/heartbeat/Dockerfile /var/tmp/notification-lambdas/"
  }

}

resource "null_resource" "push_heartbeat_docker_image" {

  depends_on = [null_resource.build_heartbeat_docker_image]

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.heartbeat.repository_url}:${random_string.heartbeat_suffix.result}"
  }

}

#Google-Cidr Build and Push
resource "random_string" "google_cidr_suffix" {
  length  = 8
  special = false
}

resource "null_resource" "build_google_cidr_docker_image" {

  depends_on = [
    null_resource.lambda_repo_clone,
    random_string.google_cidr_suffix
  ]

  provisioner "local-exec" {
    command = "docker build -t ${aws_ecr_repository.google-cidr.repository_url}:${random_string.google_cidr_suffix.result} -f /var/tmp/notification-lambdas/google-cidr/Dockerfile /var/tmp/notification-lambdas/google-cidr"
  }

}

resource "null_resource" "push_google_cidr_docker_image" {

  depends_on = [null_resource.build_google_cidr_docker_image]

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.google-cidr.repository_url}:${random_string.google_cidr_suffix.result}"
  }

}

# SES Receiving Emails Build and Push
resource "random_string" "ses_receiving_emails_suffix" {
  length  = 8
  special = false
}

resource "null_resource" "build_ses_receiving_emails_docker_image" {

  depends_on = [
    null_resource.lambda_repo_clone,
    random_string.ses_receiving_emails_suffix
  ]

  provisioner "local-exec" {
    command = "docker build -t ${aws_ecr_repository.ses_receiving_emails.repository_url}:${random_string.ses_receiving_emails_suffix.result} -f /var/tmp/notification-lambdas/sesreceivingemails/Dockerfile /var/tmp/notification-lambdas"
  }

}

resource "null_resource" "push_ses_receiving_emails_docker_image" {

  depends_on = [null_resource.build_ses_receiving_emails_docker_image]

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.ses_receiving_emails.repository_url}:${random_string.ses_receiving_emails_suffix.result}"
  }

}

# SES Receiving Emails Build and Push
resource "random_string" "ses_to_sqs_email_callbacks_suffix" {
  length  = 8
  special = false
}

resource "null_resource" "build_ses_to_sqs_email_callbacks_docker_image" {

  depends_on = [
    null_resource.lambda_repo_clone,
    random_string.ses_to_sqs_email_callbacks_suffix
  ]

  provisioner "local-exec" {
    command = "docker build -t ${aws_ecr_repository.ses_to_sqs_email_callbacks.repository_url}:${random_string.ses_to_sqs_email_callbacks_suffix.result} -f /var/tmp/notification-lambdas/sesemailcallbacks/Dockerfile /var/tmp/notification-lambdas"
  }

}

resource "null_resource" "push_ses_to_sqs_email_callbacks_docker_image" {

  depends_on = [null_resource.build_ses_to_sqs_email_callbacks_docker_image]

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.ses_to_sqs_email_callbacks.repository_url}:${random_string.ses_to_sqs_email_callbacks_suffix.result}"
  }

}

# SNS to SQS Queue Build and Push
resource "random_string" "sns_to_sqs_sms_callbacks_suffix" {
  length  = 8
  special = false
}

resource "null_resource" "build_sns_to_sqs_sms_callbacks_docker_image" {

  depends_on = [
    null_resource.lambda_repo_clone,
    random_string.sns_to_sqs_sms_callbacks_suffix
  ]

  provisioner "local-exec" {
    command = "docker build -t ${aws_ecr_repository.sns_to_sqs_sms_callbacks.repository_url}:${random_string.sns_to_sqs_sms_callbacks_suffix.result} -f /var/tmp/notification-lambdas/sesemailcallbacks/Dockerfile /var/tmp/notification-lambdas"
  }

}

resource "null_resource" "push_sns_to_sqs_sms_callbacks_docker_image" {

  depends_on = [null_resource.build_sns_to_sqs_sms_callbacks_docker_image]

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.sns_to_sqs_sms_callbacks.repository_url}:${random_string.sns_to_sqs_sms_callbacks_suffix.result}"
  }

}



