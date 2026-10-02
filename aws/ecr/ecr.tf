resource "aws_ecr_repository" "lambda_log_extension" {
  count                = var.env == "dev" ? 1 : 0
  name                 = "log-extension-image"
  image_tag_mutability = "IMMUTABLE" #tfsec:ignore:AWS078
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}


resource "aws_ecr_repository" "heartbeat" {
  name                 = "notify/heartbeat"
  image_tag_mutability = var.env == "dev" ? "IMMUTABLE" : "MUTABLE" #tfsec:ignore:AWS078
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
  #tfsec:ignore:AWS078

  name                 = "notify/api"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "document-download" {
  #tfsec:ignore:AWS078

  name                 = "notify/document-download"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "documentation" {
  #tfsec:ignore:AWS078

  name                 = "notify/documentation"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}


resource "aws_ecr_repository" "google-cidr" {
  name                 = "lambda/google-cidr"
  image_tag_mutability = var.env == "dev" ? "IMMUTABLE" : "MUTABLE" #tfsec:ignore:AWS078
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "performance-test" {
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
  name                 = "notify/ses_to_sqs_email_callbacks"
  image_tag_mutability = var.env == "dev" ? "IMMUTABLE" : "MUTABLE" #tfsec:ignore:AWS078
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "sns_to_sqs_sms_callbacks" {
  name                 = "notify/sns_to_sqs_sms_callbacks"
  image_tag_mutability = var.env == "dev" ? "IMMUTABLE" : "MUTABLE" #tfsec:ignore:AWS078
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "system_status" {
  name                 = "notify/system_status"
  image_tag_mutability = var.env == "dev" ? "IMMUTABLE" : "MUTABLE" #tfsec:ignore:AWS078
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "pinpoint_to_sqs_sms_callbacks" {
  name                 = "notify/pinpoint_to_sqs_sms_callbacks"
  image_tag_mutability = var.env == "dev" ? "IMMUTABLE" : "MUTABLE" #tfsec:ignore:AWS078
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}
