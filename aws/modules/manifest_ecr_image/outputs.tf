output "image_uri" {
  value = var.verify_ecr_image ? "${local.repository_uri}@${data.aws_ecr_image.selected[0].image_digest}" : "${local.repository_uri}:${local.image_tag}"
}