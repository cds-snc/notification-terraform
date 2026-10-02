output "image_uri" {
  value     = "${var.repository_url}:${local.image_tag}"
  sensitive = true

  precondition {
    condition     = can(regex("^[0-9a-f]{7,40}$", local.image_tag))
    error_message = "${var.tag_key} in ${local.manifest_environment}.env must be a commit SHA tag."
  }
}