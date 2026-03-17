resource "aws_ecr_repository" "pinpoint_to_sqs_sms_callbacks" {
  # The :latest tag is used in Staging

  provider             = aws.us-west-2
  name                 = "notify/pinpoint_to_sqs_sms_callbacks"
  image_tag_mutability = "MUTABLE" #tfsec:ignore:AWS078
  force_delete         = var.force_delete_ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}
