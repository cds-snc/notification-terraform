variable "force_delete_ecr" {
  description = "Boolean value to decide whether or not to force delete a non-empty ECR"
  type        = bool
  default     = false
}

variable "build_images" {
  description = "Boolean value to decide whether or not to build images"
  type        = bool
  default     = false
}