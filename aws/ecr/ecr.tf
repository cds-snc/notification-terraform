resource "aws_ecr_repository" "lambda_log_extension" {
  count                = var.env == "dev" ? 1 : 0
  name                 = "log-extension-image"
  image_tag_mutability = "MUTABLE" #tfsec:ignore:AWS078
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}


resource "aws_ecr_repository" "heartbeat" {
  # The :latest tag is used in staging

  name                 = "notify/heartbeat"
  image_tag_mutability = "MUTABLE" #tfsec:ignore:AWS078
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "notify_admin" {
  count                = var.env == "production" ? 0 : 1
  name                 = "notify/admin"
  image_tag_mutability = "MUTABLE" #tfsec:ignore:AWS078
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "api" {
  # The :latest tag is used in staging
  #tfsec:ignore:AWS078

  name                 = "notify/api"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "api-lambda" {
  # The :latest tag is used in staging
  #tfsec:ignore:AWS078

  name                 = "notify/api-lambda"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "document-download" {
  # The :latest tag is used in staging
  #tfsec:ignore:AWS078

  name                 = "notify/document-download"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "documentation" {
  # The :latest tag is used in staging
  #tfsec:ignore:AWS078

  name                 = "notify/documentation"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}


resource "aws_ecr_repository" "google-cidr" {
  # The :latest tag is used in staging

  name                 = "lambda/google-cidr"
  image_tag_mutability = "MUTABLE" #tfsec:ignore:AWS078
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "performance-test" {
  # The :latest tag is used in staging
  #tfsec:ignore:AWS078

  count                = var.env == "production" ? 0 : 1
  name                 = "notify/performance-test"
  image_tag_mutability = "MUTABLE" #tfsec:ignore:AWS078
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "ses_to_sqs_email_callbacks" {
  # The :latest tag is used in staging

  name                 = "notify/ses_to_sqs_email_callbacks"
  image_tag_mutability = "MUTABLE" #tfsec:ignore:AWS078
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "sns_to_sqs_sms_callbacks" {
  # The :latest tag is used in staging

  name                 = "notify/sns_to_sqs_sms_callbacks"
  image_tag_mutability = "MUTABLE" #tfsec:ignore:AWS078
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "system_status" {
  # The :latest tag is used in staging

  name                 = "notify/system_status"
  image_tag_mutability = "MUTABLE" #tfsec:ignore:AWS078
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "pinpoint_to_sqs_sms_callbacks" {
  # The :latest tag is used in staging

  name                 = "notify/pinpoint_to_sqs_sms_callbacks"
  image_tag_mutability = "MUTABLE" #tfsec:ignore:AWS078
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}
